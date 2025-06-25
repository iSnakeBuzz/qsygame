class_name ItemData
extends Resource

@export var prefab: PackedScene
@export var image: Texture2D
@export var display_name: String
@export var purchase_price: int

func _init(p_prefab: PackedScene = null, p_image: Texture2D = null, p_display_name: String = "", p_purchase_price: int = 0):
	prefab = p_prefab
	image = p_image
	display_name = p_display_name
	purchase_price = p_purchase_price
