extends Node

var customerObj = preload("res://objects/customer.tscn")

var customers: Array[Customer]

func _ready() -> void:
	_createCustomers.call_deferred()

func _createCustomers():
	print("Generating 100 NPCs")
	await get_tree().physics_frame
	for custId in range(100):
		var customer = customerObj.instantiate()
		customer.name = "Customer %s" % [custId]
		customer.position = Game.getLocation(Game.TeleportLocation.Pool)

		Game.PlaceRegion.add_child(customer)
		addCustomer(customer)

func addCustomer(customer: Customer) -> void:
	customers.append(customer)

func removeCustomer(customer: Customer) -> void:
	customers.pop_at(customers.find(customer))
