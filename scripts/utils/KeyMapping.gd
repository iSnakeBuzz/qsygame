class_name KeyMapping

var name: String = ""
var positionX: int = 0
var positionY: int = 0
var width: int = 0
var height: int = 0

func _init(_name: String, _positionX: int, _positionY: int, _width: int, _height: int) -> void:
	name = _name
	positionX = _positionX
	positionY = _positionY
	width = _width
	height = _height

func get_name() -> String:
	return name

func get_position() -> Vector2:
	return Vector2(positionX, positionY)

func get_width() -> int:
	return width

func get_height() -> int:
	return height

func get_rect_position() -> Rect2:
	return Rect2(positionX, positionY, width, height)
