class_name WashingMachine extends Entity

enum WashingStatus {
	Setup,
	Free,
	Waiting,
	Washing,
	Finished
}

@onready var allowed_placement: Material = preload("res://materials/allowed_placement.tres")
@onready var unallowed_placement: Material = preload("res://materials/unallowed_placement.tres")

@onready var labelName: Label3D = $Dev/LabelName
@onready var area: Area3D = $Area
@onready var raycasts: Array[RayCast3D] = [$Ray1, $Ray2, $Ray3, $Ray4]
@onready var body: StaticBody3D = $Area/StaticBody
@onready var interact_action: Node3D = $InteractAction

@export var meshes: Array[MeshInstance3D]
@export var upgrades: Dictionary[Upgrade.Type, Upgrade]

var status: WashingStatus = WashingStatus.Setup

var editing: bool = false
var startedWashingAt: int = 0
var currentCustomer: Customer = null

func _ready() -> void:
	labelName.text = "Waiting"

	# Disable body collision
	body.set_collision_layer(0)

func _process(_delta: float) -> void:
	changeStatus()
	if status != WashingStatus.Washing: return

	var currentTime = Time.get_ticks_msec()
	var elapsedTime = (currentTime - startedWashingAt) / 1000.0

	if elapsedTime >= maxWashingTime():
		setStatus(WashingStatus.Finished)

func _unallowed_placement() -> void:
	for mesh in meshes:
		mesh.material_override = unallowed_placement

func _allowed_placement() -> void:
	for mesh in meshes:
		mesh.material_override = allowed_placement

func _clean_placement() -> void:
	for mesh in meshes:
		mesh.material_override = null

func check_placement() -> bool:
	for ray in raycasts:
		if not ray.is_colliding():
			_unallowed_placement()
			return false

	if area.get_overlapping_areas():
		_unallowed_placement()
		return false

	_allowed_placement()
	return true

func place() -> void:
	_clean_placement()
	body.set_collision_layer(1)
	editing = false

	if self.status == WashingStatus.Setup:
		setStatus(WashingStatus.Free)

func setStatus(_status: WashingStatus) -> void:
	var currentMillis = Time.get_ticks_msec()
	if _status == WashingStatus.Washing:
		startedWashingAt = currentMillis
	self.status = _status

func getNPCLocation() -> Vector3:
	return $NPCLoc.global_position

func setCurrentCustomer(cust: Customer) -> void:
	self.currentCustomer = cust

func changeStatus() -> void:
	var player = Game.Player
	var isColliding = player.interact_cast.is_colliding() and player.interact_cast.get_collider() == body
	var isPlacing = editing or PlacementManager.is_placing()

	labelName.visible = isColliding
	labelName.text = "Status: %s | Client: %s | Elapsed: %.2f/%.2f" % [getStatus(), getCurrentCustomerName(), getElapsedTime(), maxWashingTime()]
	interact_action.visible = isColliding and not isPlacing

func getStatus() -> String:
	if status == WashingStatus.Waiting:
		return "Waiting"
	if status == WashingStatus.Washing:
		return "Washing"
	if status == WashingStatus.Finished:
		return "Finished"
	return "Free"

func getCurrentCustomerName() -> String:
	if self.currentCustomer:
		return self.currentCustomer.name
	return "none"

func getElapsedTime() -> float:
	if status != WashingStatus.Washing: return 0
	return (Time.get_ticks_msec() - startedWashingAt) / 1000.0

func maxWashingTime() -> float:
	if not upgrades.has(Upgrade.Type.Speed): return 5
	return upgrades[Upgrade.Type.Speed].calculateValue()

func _on_move_interaction_handler_interact_call() -> void:
	if editing: return
	print("[%s] Handling logic to move the Washing Machine" % [self.name])
	PlacementManager.set_editing_instance(self)
	editing = true

func _on_upgrades_interaction_handler_interact_call() -> void:
	if editing: return
	print("[%s] Opening Upgrades Menu" % self.name)
	Game.openMenu(Game.MenuType.Upgrades, self)

func calculateReward() -> int:
	if not upgrades.has(Upgrade.Type.Money): return 5
	var money: Upgrade = upgrades.get(Upgrade.Type.Money)
	return int(money.calculateValue())