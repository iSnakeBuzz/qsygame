class_name GameManager extends Node

enum TeleportLocation {
	Pool,
	Door
}

enum MenuType {
	Main,
	Upgrades,
	Store,
}

signal ON_MENU_CLOSE
signal ON_MENU_OPEN(menu_type: MenuType, data: Node3D)
signal ON_INPUT_DEVICE_CHANGE(device_id: int)

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
	_hook_discord()

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
	if Input.is_action_just_pressed("store"):
		if on_menu():
			closeMenu()
		else:
			openMenu(MenuType.Store)

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
	entity.visible = false
	var position: Vector3 = getLocation(location)
	entity.position = position
	entity.visible = true

func addLocation(location: TeleportLocation, position: Vector3) -> void:
	_locations.set(str(location).to_lower(), position)

func getLocation(location: TeleportLocation) -> Vector3:
	return _locations.get(str(location).to_lower())

# Add money to the player
func addCash(money: int) -> void:
	self.Money += money

# Set mouse mode to visible or captured
func updateMouse(visible: bool) -> void:
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Emit signal to close all menus
func closeMenu() -> void:
	updateMouse(false)
	ON_MENU_CLOSE.emit()

# Emit signal to open a menu with optional data
func openMenu(menu_type: MenuType, data: Node3D = null) -> void:
	ON_MENU_OPEN.emit(menu_type, data)

# Check if the user has any menu open
func on_menu() -> bool:
	return Input.mouse_mode == Input.MOUSE_MODE_VISIBLE

func _hook_discord() -> void:
	# Application ID
	DiscordRPC.app_id = 1388388422036754472
	# this is boolean if everything worked
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
	# Set the first custom text row of the activity here
	DiscordRPC.details = "-"
	# Set the second custom text row of the activity here
	DiscordRPC.state = "a"
	# Image key for small image from "Art Assets" from the Discord Developer website
	# "02:41 elapsed" timestamp for the activity
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	# "59:59 remaining" timestamp for the activity
	DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600
	# Always refresh after changing the values!
	DiscordRPC.refresh()

	print("Discord: %s " % DiscordRPC.get_current_user())