extends Interactible
class_name IntServe
func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true

func store(i:Movable) -> bool:
	if(i is MovableCooker):
		i.empty()
		return true
	elif(i is Ingredient):
		i.parent.objectInHand = null
		i.queue_free()
		return true
	return false
