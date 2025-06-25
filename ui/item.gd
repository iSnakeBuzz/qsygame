class_name BuildItem
extends PanelContainer

@onready var hovering_item = $Hovering
@onready var item_image: TextureRect = $ImageMarginContainer/ImagePanel/ImageMargin/Image

var resource: PackedScene
var display_name: String
var purchase_price: int

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
	hovering_item.visible = false
	print("[%s] Mouse exited item" % [self.display_name])

func _on_mouse_entered() -> void:
	hovering_item.visible = true
	print("[%s] Mouse entered item" % [self.display_name])
