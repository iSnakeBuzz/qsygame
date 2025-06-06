extends Node

var customers: Array[Customer]

func addCustomer(customer: Customer) -> void:
	customers.append(customer)

func removeCustomer(customer: Customer) -> void:
	customers.pop_at(customers.find(customer))

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	if event.is_action_pressed("ui_accept"):
		_test_update_location()

func _test_update_location() -> void:
	var newPosition = Game.Player.position;
	print("New position set to %s" % [newPosition])
	for customer in customers:
		customer.setTarget(newPosition)
