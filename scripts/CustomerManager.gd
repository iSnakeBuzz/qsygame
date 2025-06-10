extends Node

var customerObj = preload("res://objects/customer.tscn")

var customers: Array[Customer]
var lastExecuted: int = 0

func _ready() -> void:
	_createCustomers.call_deferred()

func _process(_delta: float) -> void:
	if not _canRun(): return

	var finishedCustomers = 0
	var customerSize = len(customers)

	for cust in customers:
		if cust.status != Customer.ClientStatus.Finished: continue
		finishedCustomers += 1
	
	print("Finished %s/%s" % [finishedCustomers, customerSize])
	lastExecuted = Time.get_ticks_msec()


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

func _canRun() -> bool:
	var currentTime = Time.get_ticks_msec()
	return currentTime - lastExecuted > 1000
