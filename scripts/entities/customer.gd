class_name Customer
extends CharacterBody3D

@onready var navigation: NavigationAgent3D = $NavigationAgent3D

@export var gravity_enabled: bool = true
@export var dynamic_gravity: bool = false
@export var speed: float = 100.0
@export var meshes: Array[MeshInstance3D]

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _timer: float = 0.0

var currentMachine: WashingMachine = null

func _ready() -> void:
	Customers.addCustomer(self)
	set_physics_process(false)
	_apply_random_color()
	_agent_setup.call_deferred()
	setTarget(self.position)

func _physics_process(delta: float) -> void:
	# Gravity
	if dynamic_gravity:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	if not is_on_floor() and gravity and gravity_enabled:
		velocity.y -= gravity * delta

	if not navigation.is_target_reached() and navigation.is_target_reachable():
		var target = navigation.get_next_path_position()
		target.y = 0 # Remove Y velocity due to Gravity

		velocity = global_transform.origin.direction_to(target) * speed * delta
		look_at(Vector3(target.x, global_transform.origin.y, target.z), Vector3.UP)
		move_and_slide()

func _process(delta: float) -> void:
	var canRun = _canRun(delta);
	if not canRun: return

	if currentMachine:
		_handleCurrentMachineLogic()
		return
	
	_handleNewMachineLogic()

func _handleCurrentMachineLogic() -> void:
	print("[%s] Waiting for the machine %s to finish." % [self.name, currentMachine.name])
	pass

func _handleNewMachineLogic() -> void:
	print("[%s] Waiting for a free machine :(" % [self.name])
	pass

func setTarget(target: Vector3) -> void:
	navigation.target_position = target

func _canRun(delta: float) -> bool:
	_timer += delta
	if _timer < 1.0:
		return false
	_timer = 0.0
	return true

func _agent_setup() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _apply_random_color() -> void:
	for mesh in meshes:
		mesh.material_override = _random_material()

func _random_material() -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	var color = _generate_random_color()
	material.albedo_color = color
	return material

func _generate_random_color() -> Color:
	var r = randf_range(0.2, 0.8)
	var g = randf_range(0.2, 0.8)
	var b = randf_range(0.2, 0.8)
	return Color(r, g, b)
