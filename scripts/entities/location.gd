extends Node3D

@export var locationName: Game.TeleportLocation

func _ready() -> void:
	if not locationName:
		return
	Game.addLocation(str(locationName), self.position)