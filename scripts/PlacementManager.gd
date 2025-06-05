extends Node

@onready var WashingMachineObject = preload("res://objects/washing_machine.tscn")

var instance: Node3D
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

	print("Instance position: " + str(instance.transform.origin) + " Collision position: " + str(collision))
	instance.transform.origin = collision

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

func _handle_keys(event: InputEventKey) -> void:
	if not event.pressed:
		return

	if event.is_action_pressed("key_1") and not placing:
		instance = WashingMachineObject.instantiate()
		add_child(instance)
		placing = true
		print("Instance created")
	elif event.is_action_pressed("key_0") and instance:
		instance.queue_free()
		instance = null
		placing = false
		target_rotation_y = 0.0
		print("Instance destroyed")
	elif event.is_action_pressed("action"):
		if can_place:
			pass
