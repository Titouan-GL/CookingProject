extends Control

@onready var button = $Button
@onready var orderTemplate = $Order
@onready var orderContainer = $HBoxContainer

signal expired_order(order: Recipe)

func _ready() -> void:
	var parent = get_parent()
	parent.connect("addedOrder", addOrder)
	parent.connect("removedOrder", removeOrder)
	orderTemplate.visible = false

func addOrder(order):
	var newOrder = orderTemplate.duplicate()
	newOrder.recipe = order
	newOrder.visible = true
	newOrder.priority = get_child_count()
	orderContainer.add_child(newOrder)
	newOrder.set_custom_minimum_size(Vector2(150, 30))
	newOrder.set_up()
	
func removeOrder(o: Control):
	o.queue_free()

func _process(delta: float) -> void:
	for child in orderContainer.get_children():
		child.time = max(0, child.time - delta)
		var ExpireBar = child.get_node("Panel").get_node("ExpireBar")
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1 - (child.time/Config.ORDER_EXPIRE_TIME), child.time/Config.ORDER_EXPIRE_TIME, 0)
		ExpireBar.size.x = child.get_node("Panel").size.x * (child.time/Config.ORDER_EXPIRE_TIME)
		ExpireBar.add_theme_stylebox_override("panel", style)
		if (child.time == 0):
			removeOrder(child)
			emit_signal("expired_order", child.recipe)
