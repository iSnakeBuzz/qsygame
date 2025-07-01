extends CanvasLayer

@export var inventories: Dictionary[Game.MenuType, MenuAnimatorHelper] = {}

func _ready() -> void:
	# Hide all available inventories at the start
	for inventory in inventories.values():
		inventory.visible = false

	Game.ON_MENU_CLOSE.connect(self.on_menu_close)
	Game.ON_MENU_OPEN.connect(self.on_menu_open)

func on_menu_open(menu_type: Game.MenuType, data: Node3D = null) -> void:
	var currentInventory: MenuAnimatorHelper = self.is_any_open()
	if currentInventory:
		currentInventory.closeMenu()

	var inventoryNode = inventories.get(menu_type)
	if not inventoryNode:
		push_error("InventoryNode or Animation name(%s) is inexistent." % menu_type)
		return

	inventoryNode.openMenu(data)
	print("[GUIManager] Opened %s menu with data: %s" % [menu_type, data])

func on_menu_close() -> void:
	for inventory in inventories.values():
		inventory.closeMenu()
	print("[GUIManager] Closed all menus")

func is_any_open() -> MenuAnimatorHelper:
	for inventory in inventories.values():
		if inventory.is_open():
			return inventory
	return null
