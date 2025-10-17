extends Node3D

# TODO: Change stands into classes so its easier to know if it is aviable and which ingredient can go inside
# TODO: multiple recipes/ingredients can be picked up at once when the player holds a plate. Create that plate
var active_orders: Array = []
var recipes_aviable: Array[Recipe] = []
var totalPoints = 0
var multiplier = 1
var time = Config.MAX_TIME
@onready var GUIController = $Control

signal addedOrder(order)
signal removedOrder(order)

func get_composite_recipes() -> Array[Recipe]:
	return recipes_aviable.filter(func(r): return not r.recipeNeeded.is_empty())

func add_random_order(amount: int):
	for i in range(amount):
		var possible_orders = get_composite_recipes()
		if possible_orders.is_empty():
			return
		var order = possible_orders.pick_random()
		active_orders.append(order.name)
		emit_signal("addedOrder", order)

func order_expired(recipe: Recipe):
	totalPoints -= Config.SCORE_PENALTY_EXPIRE_ORDER
	active_orders.erase(recipe.name)
	multiplier = 1
	print("Order expired! total points: ", str(totalPoints), ", multiplier: ", str(multiplier))
	add_random_order(1)

func _ready() -> void:
	var bot = $agent
	recipes_aviable = load_all_recipes("res://data/recipe")
	bot.SPEED = Config.BOT_SPEED # Overrides the speed value set in player.gd
	bot.CARRY_SPEED = Config.BOT_SPEED_ON_CARRY
	add_random_order(Config.MAX_ORDER)
	GUIController.connect("expired_order", order_expired)

func orderComplete(firstOrder: bool, O: Control):
	# ATTENTION: When the order classes are created, we need to have the command completed as secondary parameter
	totalPoints += Config.SCORE_PER_ORDER * multiplier
	if firstOrder and multiplier != Config.MAX_SCORE_MULTIPLIER:
			multiplier = multiplier + Config.SCORE_MULTIPLIER_FACTOR - 1
	active_orders.erase(O.recipe.name)
	emit_signal("removedOrder", O)
	add_random_order(1)

func load_all_recipes(path: String) -> Array[Recipe]:
	var dir = DirAccess.open(path)
	var recipes: Array[Recipe] = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var recipe = load(path + "/" + file_name)
				if recipe is Recipe:
					recipes.append(recipe)
			file_name = dir.get_next()
	return recipes
	
var random_interval_to_test_caus_y_not = 4

func _process(delta: float) -> void:
	random_interval_to_test_caus_y_not = max(0, random_interval_to_test_caus_y_not - delta)
	if random_interval_to_test_caus_y_not == 0:
		random_interval_to_test_caus_y_not = 4
		var Order = GUIController.get_node("HBoxContainer").get_child(0)
		orderComplete(true, Order)
		print("Order completed (imagine it did, trust), total points: ", str(totalPoints), ", multiplier: ", str(multiplier))
