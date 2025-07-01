class_name Interaction
extends Node3D

signal interact_call

@export var interact_key: StringName
@export var progressbar: TextureProgressBar
@export var press_duration: float = 1.0
@export var interacting_with: StaticBody3D
@export var disable_on_placement: bool = false

var startedAt: int = 0

func _process(_delta: float) -> void:
	handleInteractionProgress()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventJoypadButton: return
	if Game.on_menu(): return
	if not are_interacting_with_us(): return

	if Input.is_action_just_pressed(self.interact_key):
		handleInteractionStart()
	elif Input.is_action_just_released(self.interact_key):
		handleInteractionCancel()

func handleInteractionStart() -> void:
	startedAt = Time.get_ticks_msec()
	print("[%s] Interaction started" % self.name)

func handleInteractionCancel() -> void:
	startedAt = 0
	progressbar.value = 0.0

func handleInteractionProgress() -> void:
	if PlacementManager.is_placing() and disable_on_placement: return
	if not are_interacting_with_us(): return
	if startedAt == 0: return

	var elapsed = Time.get_ticks_msec() - startedAt
	var progress = clamp((elapsed / (press_duration * 1000.0)) * 100.0, 0, 100)
	progressbar.value = progress

	if progress >= 100.0:
		interact_call.emit()
		handleInteractionCancel()

func are_interacting_with_us() -> bool:
	var player = Game.Player
	return player.interact_cast.is_colliding() and player.interact_cast.get_collider() == interacting_with