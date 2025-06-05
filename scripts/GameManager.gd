class_name GameManager extends Node

var _PRICES: Dictionary = {
	"washing_machine": 1000,
}
var _machines: Array[WashingMachine]

var Player: PlayerController
var Money: int = 999

func purchaseWashingMachine(machine: WashingMachine) -> void:
	var price = _PRICES["washing_machine"]

	if Money < price:
		print("You do not have enough money to buy this machine")
		return

	Money -= price
	_machines.append(machine)
	print("Dinerito updated and machine placed.")
