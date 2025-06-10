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
var _debug: bool = false

var Player: PlayerController
var PlaceRegion: NavigationRegion3D
var Money: int = 9999999

func _input(event: InputEvent) -> void:
	if not event is InputEventKey: return

	if event.is_action_pressed("debug"):
		_debug = !_debug

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
	var position: Vector3 = getLocation(location)

	entity.position = position

func addLocation(location: TeleportLocation, position: Vector3) -> void:
	_locations.set(str(location).to_lower(), position)

func getLocation(location: TeleportLocation) -> Vector3:
	return _locations.get(str(location).to_lower())

func addCash(money: int) -> void:
	self.Money += money
