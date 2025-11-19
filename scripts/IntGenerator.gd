extends Interactible

class_name IntGenerator
const ingredient = preload("res://scenes/ingredient.tscn")
@export var recipeType:Enum.RecipeNames

func _enter_tree():
	taskType = Enum.TaskType.GENERATE
	add_to_group("Generator"+Enum.RecipeNames.keys()[recipeType])
	passive = true
	canBeOccupied = false
	super._enter_tree()

func store(i:Movable) -> bool:
	if i.recipe == recipeType:
		i.parent.objectInHand = null
		i.queue_free()
		return true
	return false
	
	
func unstore() -> Movable:
	var inst = ingredient.instantiate()
	inst.recipe = recipeType
	get_tree().current_scene.add_child(inst)
	inst.set_global_position(position)
	return inst

func _process(_delta):
	super._process(_delta)
