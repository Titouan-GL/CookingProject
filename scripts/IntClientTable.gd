extends Interactible

class_name ClientTable
var servePoints:Array[IntServe]

func store(i:Movable) -> bool:
	var shortest_time = null
	for s in servePoints:
		if s.recipeWanted == i.recipe and s.available:
			if not shortest_time or shortest_time.timeLeft > s.timeLeft:
				shortest_time = s
	if shortest_time:
		return shortest_time.store(i)
	return false

func _enter_tree():
	super._enter_tree()
	taskType = Enum.TaskType.NONE
	passive = true
	canBeOccupied = false
	
func _ready():
	for c in get_children():
		if c is IntServe:
			servePoints.append(c)
