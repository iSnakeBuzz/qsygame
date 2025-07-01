class_name BuildMenu
extends HBoxContainer

@onready var BuildItemPreload = preload("res://ui/item.tscn")
@onready var building_grid: VBoxContainer = $VBoxContainer/Content/VBoxContainer

@export var items: Array[ItemData]
@export var hover_color: Color = Color(1, 1, 1, 1)

func _ready() -> void:
	print("Items: %s %s" % [items, items.size()])
	for item in items:
		var build_item = BuildItemPreload.instantiate()
		building_grid.add_child(build_item)

		await get_tree().process_frame

		build_item.display_name = item.display_name
		build_item.purchase_price = item.purchase_price
		build_item.item_image.texture = item.image
		build_item.color = hover_color
		build_item.metadata = {
			"resource": item.prefab,
			"purchase_price": item.purchase_price,
		}
		build_item.on_clicked.connect(on_item_purchase)

func on_item_purchase(metadata: Dictionary) -> void:
	var resource = metadata["resource"]
	var purchase_price = metadata["purchase_price"]

	PlacementManager.WashingMachineObject = resource
	PlacementManager._create()
	PlacementManager.placing = true
	PlacementManager.selected_price = purchase_price

	Game.closeMenu()