extends HBoxContainer

@onready var BuildItemPreload = preload("res://ui/item.tscn")
@onready var building_grid: VBoxContainer = $VBoxContainer/Content/VBoxContainer

@export var hover_color: Color = Color(1, 1, 1, 1)

var current_washing_machine: WashingMachine

func _on_upgrades_shop_on_data_set(data: WashingMachine) -> void:
	if not data:
		_clear_data(true)
		return

	current_washing_machine = data
	_update_data(data.upgrades)

func _clear_data(clear_current_washing_machine: bool = false) -> void:
	if clear_current_washing_machine:
		current_washing_machine = null

	for child in building_grid.get_children():
		child.queue_free()

func _update_data(data: Dictionary[Upgrade.Type, Upgrade]) -> void:
	_clear_data()
	for upgrade in data:
		var item = data[upgrade]
		var build_item = BuildItemPreload.instantiate()
		building_grid.add_child(build_item)

		build_item.display_name = item.display_name
		build_item.description = item.description
		build_item.purchase_price = item.calculatePrice()
		build_item.item_image.texture = item.image
		build_item.color = hover_color
		build_item.amount = item.level
		build_item.maxed = item.maxedOut()

		build_item.metadata = {
			"type": upgrade,
		}
		build_item.on_clicked.connect(on_item_purchase)

func on_item_purchase(metadata: Dictionary) -> void:
	print("Item purchased: %s" % metadata)
	var type: Upgrade.Type = metadata["type"]
	
	if not current_washing_machine.upgrades[type].upgrade():
		return
	
	_update_data(current_washing_machine.upgrades)
