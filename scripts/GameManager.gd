class_name GameManager extends Node

enum TeleportLocation {
	Pool,
	Door
}

signal ON_MENU_CLOSE
signal ON_INPUT_DEVICE_CHANGE(device_id: int)

var _mouseVisible: bool = true
var _locations: Dictionary

var _machines: Array[WashingMachine]
var _otherEntities: Array[Entity]

var _debug: bool = false
var _input_device_id: int = -1

var Player: PlayerController
var PlaceRegion: NavigationRegion3D
var Money: int = 9999999


func _ready() -> void:
	Input.connect("joy_connection_changed", self._joy_connection_changed)
	self.set_process_unhandled_input(true)

func _joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		_input_device_id = device_id
		ON_INPUT_DEVICE_CHANGE.emit(_input_device_id)
	elif not connected and _input_device_id == device_id:
		_input_device_id = -1
		ON_INPUT_DEVICE_CHANGE.emit(_input_device_id)

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventKey and _input_device_id != -1) or (event is InputEventJoypadButton and _input_device_id != 1):
		_input_device_id = -1 if event is InputEventKey else event.device
		ON_INPUT_DEVICE_CHANGE.emit(_input_device_id)

	if not event is InputEventKey: return

	if event.is_action_pressed("debug"):
		_debug = !_debug

func purchaseEntityObject(entity: Entity, price: int) -> bool:
	if Money < price:
		print("You do not have enough money to buy this machine")
		return false

	Money -= price

	if entity is WashingMachine:
		_machines.append(entity)
	else:
		_otherEntities.append(entity)
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

func updateMouse(visible: bool) -> void:
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouseVisible = visible

func closeMenu() -> void:
	ON_MENU_CLOSE.emit()
	updateMouse(false)
