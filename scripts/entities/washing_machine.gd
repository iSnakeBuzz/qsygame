class_name WashingMachine extends Node3D

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

@export var meshes: Array[MeshInstance3D]
@export var status: WashingStatus = WashingStatus.Free

var washingTime: int = 10 # In seconds
var startedWashingAt: int = 0
var currentCustomer: Customer = null

func _ready() -> void:
	labelName.text = "Waiting"

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
	labelName.text = "Status: %s | Client: %s" % [getStatus(), getCurrentCustomerName()]

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