extends Interactible
class_name IntServe

var hierarchy:Hierarchy

func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true

func _ready():
	super._ready()
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]

func store(i:Movable) -> bool:
	if(i is MovableCooker):
		hierarchy.recipeServed(i.recipe)
		i.empty()
		return true
	elif(i is Ingredient):
		hierarchy.recipeServed(i.recipe)
		i.parent.objectInHand = null
		i.queue_free()
		return true
	return false
