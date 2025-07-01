class_name BuildItem
extends PanelContainer

signal on_clicked(metadata: Dictionary)

@onready var item_image: TextureRect = $PanelContainer/HBoxContainer/ImageCN/ImageMargin/Image
@onready var money_label: Label = $PanelContainer/HBoxContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/MoneyLabel
@onready var item_name_label: Label = $PanelContainer/HBoxContainer/VBoxContainer/ItemName
@onready var description_label: Label = $PanelContainer/HBoxContainer/VBoxContainer/Description

@onready var money_container: PanelContainer = $PanelContainer/HBoxContainer/VBoxContainer/MoneyContainer
@onready var maxed_container: PanelContainer = $PanelContainer/HBoxContainer/VBoxContainer/MaxedContainer

@onready var amount_container: PanelContainer = $PanelContainer/HBoxContainer/ImageCN/Amount
@onready var amount_label: Label = $PanelContainer/HBoxContainer/ImageCN/Amount/MarginContainer/Label

var display_name: String:
	set(value):
		display_name = value
		item_name_label.text = value
var description: String:
	set(value):
		description = value
		_load_description()
var purchase_price: int:
	set(value):
		purchase_price = value
		money_label.text = add_commas_to_int(value)
var amount: int:
	set(value):
		amount = value
		amount_label.text = "x%s" % value
		amount_container.visible = value > 0
var color: Color = Color(1, 1, 1, 1):
	set(value):
		self.normal_stylebox.bg_color = Color(value.r, value.g, value.b, 0)
		self.hover_stylebox.bg_color = Color(value.r, value.g, value.b, 1.0)
var maxed: bool = false:
	set(value):
		maxed = value
		money_container.visible = not value
		maxed_container.visible = value

var metadata: Dictionary = {}

var normal_stylebox: StyleBoxFlat
var hover_stylebox: StyleBoxFlat

func _ready() -> void:
	self.name = _get_name_based_logic()
	_load_description()
	_create_styleboxes()

func _create_styleboxes() -> void:
	# Create StyleBoxes once and store them
	var base_style = self.get_theme_stylebox("panel")
	if not base_style:
		print("[Item] Failed to get stylebox for item %s" % self.name)
		return

	normal_stylebox = base_style.duplicate()
	hover_stylebox = base_style.duplicate()

	if not normal_stylebox or not hover_stylebox:
		print("[Item] Failed to create styleboxes for item %s" % self.name)
		return

	normal_stylebox.bg_color = Color(color.r, color.g, color.b, 0)
	hover_stylebox.bg_color = Color(color.r, color.g, color.b, 1.0)

	_on_mouse_exited()

func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	print("[%s] Mouse pressed item %s" % [self.name, event.is_pressed()])
	on_clicked.emit(metadata)

func _on_mouse_exited() -> void:
	print("[%s] Mouse exited item" % [self.name])
	self.remove_theme_stylebox_override("panel")
	self.add_theme_stylebox_override("panel", normal_stylebox)

func _on_mouse_entered() -> void:
	print("[%s] Mouse entered item" % [self.name])
	self.remove_theme_stylebox_override("panel")
	self.add_theme_stylebox_override("panel", hover_stylebox)

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

func _get_name_based_logic() -> String:
	return "%s-%s" % [self.name, self.purchase_price]

func _load_description() -> void:
	if (description == ""): return
	description_label.text = description
	description_label.visible = true
