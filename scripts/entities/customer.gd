class_name Customer
extends CharacterBody3D

enum ClientStatus {
	Waiting,
	Finished
}

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var labelName: Label3D = $LabelName

@export var gravity_enabled: bool = true
@export var dynamic_gravity: bool = false
@export var speed: float = 100.0
@export var meshes: Array[MeshInstance3D]

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _timer: float = 0.0

var status: ClientStatus = ClientStatus.Waiting
var currentMachine: WashingMachine = null
var cooldown: int = 0

#region Setup
func _ready() -> void:
	Customers.addCustomer(self)
	set_physics_process(false)
	_apply_random_color()
	_agent_setup.call_deferred()
	labelName.text = self.name
	navigation.velocity_computed.connect(_on_velocity_computed)

func _physics_process(delta: float) -> void:
	# Gravity
	if dynamic_gravity:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	if not is_on_floor() and gravity and gravity_enabled:
		velocity.y -= gravity * delta

	if navigation.is_navigation_finished():
		return

	var current_position = global_position
	var target = navigation.get_next_path_position()
	target.y = 0 # Remove Y velocity due to Gravity

	var _velocity = current_position.direction_to(target) * speed * delta
	var target_pos = Vector3(target.x, current_position.y, target.z)

	if not current_position.is_equal_approx(target_pos):
		look_at(target_pos, Vector3.UP)

	if navigation.avoidance_enabled:
		navigation.set_velocity(_velocity)
	else:
		move_and_slide()

func _update_label() -> void:
	labelName.text = "[%s] %s : Reached: %s" % [self.name, self.status, self.navigation.is_target_reached()]
#endregion

#region Navigation

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

#endregion

#region Customer Logic

func _process(delta: float) -> void:
	_update_label()

	var canRun = _canRun(delta);
	if not canRun: return

	if currentMachine:
		_handleCurrentMachineLogic()
		return
	
	_handleNewMachineLogic()

func _handleCurrentMachineLogic() -> void:
	var navigating = not navigation.is_navigation_finished() and not navigation.is_target_reached()

	if not navigating and currentMachine != null and currentMachine.status == WashingMachine.WashingStatus.Finished:
		setTarget(Game.getLocation(Game.TeleportLocation.Door))

	pass

func _handleNewMachineLogic() -> void:
	var machine = Game.getFreeWashingMachine()
	if not machine: return
	print("[%s] I found a free machine(%s)" % [self.name, machine.name])
	currentMachine = machine;

	Game.teleportTo(self, Game.TeleportLocation.Door)
	machine.setStatus(WashingMachine.WashingStatus.Waiting)
	machine.setCurrentCustomer(self)

	# Set target after teleporting it.
	setTarget(currentMachine.getNPCLocation())

func _targetReached() -> void:
	if not currentMachine:
		print("[%s] Target reached but it doesn't have any machine assigned." % [self.name])
		return

	print("[%s] Target reached with status %s" % [self.name, currentMachine.status])

	if currentMachine.status == WashingMachine.WashingStatus.Waiting:
		currentMachine.setStatus(WashingMachine.WashingStatus.Washing)
		var target = currentMachine.global_transform.origin
		var origin = global_transform.origin
		var target_pos = Vector3(target.x, origin.y, target.z)

		if not origin.is_equal_approx(target_pos):
			look_at(target_pos, Vector3.UP)
			
	if currentMachine.status == WashingMachine.WashingStatus.Finished:
		_handleFinish()

func _handleFinish() -> void:
	self.setCooldown()
	Game.teleportTo(self, Game.TeleportLocation.Pool)
	Game.addCash(100)

	navigation.target_position = self.global_position

	currentMachine.setStatus(WashingMachine.WashingStatus.Free)
	currentMachine.setCurrentCustomer(null)
	currentMachine = null
	status = ClientStatus.Finished

#endregion

#region Utilities Functions

func setTarget(target: Vector3) -> void:
	navigation.target_position = target

func _canRun(delta: float) -> bool:
	if status != ClientStatus.Waiting: return false
	if isOnCooldown(): return false

	_timer += delta
	if _timer < 1.0:
		return false
	_timer = 0.0
	return true

func _agent_setup() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

	# Setup navigation listeners and go to the first position
	navigation.navigation_finished.connect(_targetReached)
	setTarget(self.position)

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

func isOnCooldown() -> bool:
	var currentTime = Time.get_ticks_msec()
	return currentTime - cooldown < 1000;

func setCooldown() -> void:
	cooldown = Time.get_ticks_msec()

#endregion
