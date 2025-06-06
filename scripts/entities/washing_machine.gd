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

@onready var area: Area3D = $Area
@onready var raycasts: Array[RayCast3D] = [$Ray1, $Ray2, $Ray3, $Ray4]

@export var meshes: Array[MeshInstance3D]
@export var status: WashingStatus = WashingStatus.Free

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
