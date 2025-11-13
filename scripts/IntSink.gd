extends Interactible

class_name IntSink

func _init():
	taskType = Enum.TaskType.CLEAN
	passive = false

func store(i:Movable) -> bool:
	if(!storedObject and i is Plate):
		i.parent.objectInHand = null
		storedObject = i
		storedObject.pickUp(self)
		return true
	return false
