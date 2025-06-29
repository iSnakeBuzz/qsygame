class_name WashingMachine extends Entity

enum WashingStatus {
	Setup,
	Free,
	Waiting,
	Washing,
	Finished
}

@onready var allowed_placement: Material = preload("res://materials/allowed_placement.tres")
@onready var unallowed_placement: Material = preload("res://materials/unallowed_placement.tres")

@onready var labelName: Label3D = $LabelName
@onready var area: Area3D = $Area
@onready var raycasts: Array[RayCast3D] = [$Ray1, $Ray2, $Ray3, $Ray4]
@onready var body: StaticBody3D = $Area/StaticBody
@onready var interact_action: Node3D = $InteractAction

@export var meshes: Array[MeshInstance3D]
@export var status: WashingStatus = WashingStatus.Free

var washingTime: int = 5 # In seconds
var startedWashingAt: int = 0
var currentCustomer: Customer = null

func _ready() -> void:
	labelName.text = "Waiting"

	# Disable body collision
	body.set_collision_layer(0)

func _process(_delta: float) -> void:
	changeStatus()
	if status != WashingStatus.Washing: return

	var currentTime = Time.get_ticks_msec()
	var elapsedTime = (currentTime - startedWashingAt) / 1000.0

	if elapsedTime >= washingTime:
		setStatus(WashingStatus.Finished)

func _unallowed_placement() -> void:
	for mesh in meshes:
		mesh.material_override = unallowed_placement

func _allowed_placement() -> void:
	for mesh in meshes:
		mesh.material_override = allowed_placement

func _clean_placement() -> void:
	for mesh in meshes:
		mesh.material_override = null

func check_placement() -> bool:
	for ray in raycasts:
		if not ray.is_colliding():
			_unallowed_placement()
			return false

	if area.get_overlapping_areas():
		_unallowed_placement()
		return false

	_allowed_placement()
	return true

func place() -> void:
	_clean_placement()
	body.set_collision_layer(1)

func setStatus(_status: WashingStatus) -> void:
	var currentMillis = Time.get_ticks_msec()
	if _status == WashingStatus.Washing:
		startedWashingAt = currentMillis
	self.status = _status

func getNPCLocation() -> Vector3:
	return $NPCLoc.global_position

func setCurrentCustomer(cust: Customer) -> void:
	self.currentCustomer = cust

func changeStatus() -> void:
	var player = Game.Player
	var isColliding = player.interact_cast.is_colliding() and player.interact_cast.get_collider() == body
	labelName.visible = isColliding
	labelName.text = "Status: %s | Client: %s | Elapsed: %.2f/5" % [getStatus(), getCurrentCustomerName(), getElapsedTime()]
	interact_action.visible = isColliding

func getStatus() -> String:
	if status == WashingStatus.Waiting:
		return "Waiting"
	if status == WashingStatus.Washing:
		return "Washing"
	if status == WashingStatus.Finished:
		return "Finished"
	return "Free"

func getCurrentCustomerName() -> String:
	if self.currentCustomer:
		return self.currentCustomer.name
	return "none"

func getElapsedTime() -> float:
	return (Time.get_ticks_msec() - startedWashingAt) / 1000.0
