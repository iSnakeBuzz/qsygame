class_name GameManager extends Node

enum TeleportLocation {
	Pool,
	Door
}

var _PRICES: Dictionary = {
	"washing_machine": 1000,
}

var _locations: Dictionary
var _machines: Array[WashingMachine]

var Player: PlayerController
var PlaceRegion: NavigationRegion3D
var Money: int = 2500

func purchaseWashingMachine(machine: WashingMachine) -> bool:
	var price = _PRICES["washing_machine"]

	if Money < price:
		print("You do not have enough money to buy this machine")
		return false

	Money -= price
	_machines.append(machine)
	print("Dinerito updated and machine placed.")

	_force_re_bake_async.call_deferred()
	return true

func _force_re_bake_async() -> void:
	if PlaceRegion and PlaceRegion.navigation_mesh:
		PlaceRegion.bake_navigation_mesh()
	pass

func getFreeWashingMachine() -> WashingMachine:
	for machine in _machines:
		if machine.status != WashingMachine.WashingStatus.Free:
			continue
		return machine;
	return null

func teleportTo(entity: Node3D, location: TeleportLocation) -> void:
	var position: Vector3 = getLocation(str(location))

	entity.position = position

func addLocation(location: String, position: Vector3) -> void:
	_locations.set(location.to_lower(), position)

func getLocation(location: String) -> Vector3:
	return _locations.get(location.to_lower())