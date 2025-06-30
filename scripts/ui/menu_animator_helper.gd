class_name MenuAnimatorHelper
extends Control

signal on_data_set(data: Node3D)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(self._on_animation_finished)
	animation_player.animation_started.connect(self._on_animation_started)

func _on_animation_started(anim_name: String) -> void:
	if anim_name != "open": return
	self.visible = true
	Game.updateMouse(self.visible)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name != "close":
		Game.updateMouse(self.visible)
		return
	self.visible = false
	Game.updateMouse(self.visible)

# exported functions
func openMenu(data: Node3D) -> void:
	if self.visible: return
	print("[MenuAnimatorHelper] Opening menu %s with data: %s" % [self.name, data])
	animation_player.play("open")
	on_data_set.emit(data)

func closeMenu() -> void:
	if not self.visible: return
	print("[MenuAnimatorHelper] Closing menu %s" % self.name)
	animation_player.play("close")
	on_data_set.emit(null)

func is_open() -> bool:
	return self.visible