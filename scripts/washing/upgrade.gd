class_name Upgrade
extends Resource

enum Type {
	Speed,
	Money
}

enum Target {
	WashingMachine,
}

enum Calculate {
	Remove,
	Add
}

@export var display_name: String
@export var description: String

@export_group("Upgrade Settings")
@export var type: Type
@export var target: Target

@export_group("Upgrade Pricing")
@export var price: int = 100
@export var value: float = 1
@export var price_multiplier: float = 0.1

@export_group("Upgrade Calculations")
@export var calculate: Calculate
@export var max_level: int = 10
@export var multiplier_per_level: float = 0.1

var level: int = 0

func calculatePrice() -> int:
	return roundi(price + (price * (price_multiplier * level)))

func calculateValue() -> float:
	if calculate == Calculate.Remove:
		return value - (value * (multiplier_per_level * level))
	return value + (value * (multiplier_per_level * level))

func upgrade() -> void:
	if maxedOut(): return
	level += 1
	Game.removeCash(calculatePrice())

func maxedOut() -> bool:
	return level == max_level

func extraMaxedOut() -> bool:
	return level > max_level