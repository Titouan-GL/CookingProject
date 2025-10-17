extends Control

@export var recipe: Recipe
@export var time = Config.ORDER_EXPIRE_TIME
@export var priority = 1
@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var ExpireBar = $Panel/ExpireBar

func set_up():
	label.text = recipe.name
	label.size = Vector2(150, 30)
	size = Vector2(150, 30)
	panel.size = Vector2(150, 30)
	ExpireBar.size.x = panel.size.x
	ExpireBar.size.y = 10
	ExpireBar.anchor_top = 1
	ExpireBar.anchor_bottom = 1
	ExpireBar.anchor_left = 0
	ExpireBar.anchor_right = 0
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 1, 0)
	ExpireBar.add_theme_stylebox_override("panel", style)
