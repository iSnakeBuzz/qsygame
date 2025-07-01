extends Node

var WashingMachineObject: PackedScene

var instance: WashingMachine
var target_rotation_y := 0.0
var rotation_speed := 25.0

var placing: bool = false
var can_place: bool = false

var selected_price: int = 0

func _process(_delta: float) -> void:
	if not Game.Player or not Game.Player.getCollisionWith():
		return

	var collision = Game.Player.getCollisionWith()

	if not instance:
		return

	# instance.transform.origin = _snap_to_grid(collision)
	instance.transform.origin = Vector3(collision.x, collision.y, collision.z)
	can_place = instance.check_placement()

	var current_y = instance.rotation.y
	var new_y = lerp_angle(current_y, target_rotation_y, _delta * rotation_speed)
	instance.rotation.y = new_y

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_rotate(event)

	if event is InputEventKey or event is InputEventMouseButton:
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

func _handle_keys(event: InputEvent) -> void:
	if not event.pressed:
		return

	if event.is_action_pressed("key_1") and not placing:
		_create()
		placing = true
		print("Instance created")
	elif event.is_action_pressed("key_0") and instance and not _is_editing():
		self._reset(true)
		print("Instance destroyed")

func _place() -> void:
	var isEditing = _is_editing()
	var purchased = Game.purchaseEntityObject(instance, selected_price)
	if not purchased and not isEditing:
		self._reset(true)
		return

	instance.place()
	self._reset(false)
	if not isEditing:
		self._create()
	placing = not isEditing

func _reset(delete: bool) -> void:
	if delete:
		instance.queue_free()

	instance = null
	placing = false

func _create() -> void:
	if instance: return
	if not WashingMachineObject:
		push_error("No washing machine object found")
		return

	instance = WashingMachineObject.instantiate()
	Game.PlaceRegion.add_child(instance)

func _snap_to_grid(position: Vector3, grid_size: float = 0.1) -> Vector3:
	return Vector3(
		snapped(position.x, grid_size),
		position.y,
		snapped(position.z, grid_size),
	)

func set_editing_instance(washing_machine: WashingMachine) -> void:
	instance = washing_machine
	placing = true

func _is_editing() -> bool:
	if not instance: return false
	return instance.editing

func is_placing() -> bool:
	return placing
