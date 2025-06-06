extends Node

@onready var WashingMachineObject = preload("res://objects/washing_machine.tscn")

var instance: WashingMachine
var target_rotation_y := 0.0
var rotation_speed := 25.0

var placing: bool = false
var can_place: bool = false

func _process(_delta: float) -> void:
	if not Game.Player or not Game.Player.getCollisionWith():
		return

	var collision = Game.Player.getCollisionWith()

	if not instance:
		return

	instance.transform.origin = _snap_to_grid(collision)
	can_place = instance.check_placement()

	var current_y = instance.rotation.y
	var new_y = lerp_angle(current_y, target_rotation_y, _delta * rotation_speed)
	instance.rotation.y = new_y

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_rotate(event)

	if event is InputEventKey:
		_handle_keys(event)

func _handle_rotate(event: InputEventMouseButton) -> void:
	if not event.pressed:
		return

	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		target_rotation_y += deg_to_rad(90)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		target_rotation_y -= deg_to_rad(90)
	elif event.is_action_pressed("action") and can_place and instance:
		_place()

func _handle_keys(event: InputEventKey) -> void:
	if not event.pressed:
		return

	if event.is_action_pressed("key_1") and not placing:
		_create()
		placing = true
		print("Instance created")
	elif event.is_action_pressed("key_0") and instance:
		self._reset(true)
		print("Instance destroyed")

func _place() -> void:
	var purchased = Game.purchaseWashingMachine(instance)
	if not purchased:
		self._reset(true)
		return

	instance.place()
	self._reset(false)

func _reset(delete: bool) -> void:
	if delete:
		instance.queue_free()

	instance = null
	placing = false
	target_rotation_y = 0.0

func _create() -> void:
	if instance: return
	instance = WashingMachineObject.instantiate()
	Game.PlaceRegion.add_child(instance)

func _snap_to_grid(position: Vector3, grid_size: float = 0.1) -> Vector3:
	return Vector3(
		snapped(position.x, grid_size),
		position.y,
		snapped(position.z, grid_size),
	)
