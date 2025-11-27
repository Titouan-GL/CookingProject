extends Interactible

class_name ClientTable
var servePoints:Array[IntServe]

func store(i:Movable, _proba:float=0) -> bool:
	var shortest_time = null
	for s in servePoints:
		if s.recipeWanted == i.recipe and s.available:
			if not shortest_time or shortest_time.timeLeft > s.timeLeft:
				shortest_time = s
	if shortest_time:
		if ishovered : hovered()
		return shortest_time.store(i)
	return false

func hovered():
	super.hovered()
	for s in servePoints:
		if s.storedObject and s.storedObject.recipe == s.storedObject.emptyName:
			s.hovered()
			return 
			
func unhovered():
	super.unhovered()
	for s in servePoints:
		if s.storedObject and s.storedObject.recipe == s.storedObject.emptyName:
			s.unhovered()

func unstore() -> Movable:
	for s in servePoints:
		if s.storedObject and s.storedObject.recipe == s.storedObject.emptyName:
			return s.unstore()
	return null

func _enter_tree():
	super._enter_tree()
	taskType = Enum.TaskType.NONE
	passive = true
	canBeOccupied = false
	
func _ready():
	for c in get_children():
		if c is IntServe:
			servePoints.append(c)
			c.table = self
