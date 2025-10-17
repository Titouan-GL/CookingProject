extends Interactible

class_name IntGenerator
const ingredient = preload("res://scenes/ingredient.tscn")
@export var recipeType:Enum.RecipeNames

func _enter_tree():
	taskType = Enum.TaskType.GENERATE
	add_to_group("Generator"+Enum.RecipeNames.keys()[recipeType])
	passive = true
	canBeOccupied = false

func store(_i:Movable) -> bool:
	return false
	
	
func unstore() -> Movable:
	var inst = ingredient.instantiate()
	inst.recipe = recipeType
	add_child(inst)
	inst.set_global_position(position)
	return inst

func _process(_delta):
	super._process(_delta)
