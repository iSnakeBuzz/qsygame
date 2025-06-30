class_name BuildItem
extends PanelContainer

@onready var item_image: TextureRect = $PanelContainer/HBoxContainer/ImageCN/ImageMargin/Image
@onready var money_label: Label = $PanelContainer/HBoxContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/MoneyLabel
@onready var item_name_label: Label = $PanelContainer/HBoxContainer/VBoxContainer/ItemName

var resource: PackedScene
var display_name: String:
	set(value):
		item_name_label.text = value
var purchase_price: int:
	set(value):
		money_label.text = add_commas_to_int(value)
var color: Color = Color(1, 1, 1, 1)

func _ready() -> void:
	_change_transparency(0)

func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	print("[%s] Mouse pressed item %s" % [self.display_name, event.is_pressed()])
	
	PlacementManager.WashingMachineObject = resource
	PlacementManager._create()
	PlacementManager.placing = true
	PlacementManager.selected_price = purchase_price

	Game.closeMenu()

func _on_mouse_exited() -> void:
	print("[%s] Mouse exited item" % [self.display_name])
	_change_transparency(0)

func _on_mouse_entered() -> void:
	print("[%s] Mouse entered item" % [self.display_name])
	_change_transparency(1.0)

func _change_transparency(alpha: float) -> void:
	var current_style = self.get_theme_stylebox("panel")
	current_style.bg_color = Color(color.r, color.g, color.b, alpha)
	self.add_theme_stylebox_override("panel", current_style)

func add_commas_to_int(value: int) -> String:
	var str_value = str(value)
	var result = ""
	var count = 0
	for i in range(str_value.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			result = "," + result
		result = str_value[i] + result
		count += 1
	return result
