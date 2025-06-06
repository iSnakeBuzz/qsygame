extends Node3D

@export var locationName: Game.TeleportLocation = Game.TeleportLocation.Door

func _ready() -> void:
	Game.addLocation(locationName, self.global_position)