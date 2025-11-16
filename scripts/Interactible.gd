extends Hoverable

class_name Interactible
@export var storePoint:Node3D
@export var storedObject:Movable
var taskType:Enum.TaskType
var storedIngredient:Ingredient
var progressSpeed:float = 1
var passive:bool
var occupied:bool = false
var canBeOccupied:bool = true
var obstacle = true

func _enter_tree():
	super._enter_tree()
	add_to_group("Int"+Enum.TaskType.keys()[taskType])
	add_to_group("interactible")
	if(not storePoint):
		printerr("store point of " + name +" not assigned")

func use(delta:float) -> bool:
	if(storedObject):
		if(storedObject.addProgress(taskType, delta*progressSpeed)):
			occupied = false
			return true
	return false


func store(i:Movable) -> bool:
	if(!storedObject):
		i.parent.objectInHand = null
		storedObject = i
		storedObject.pickUp(self)
		return true
	elif storedObject is MovableStorage:
		if storedObject.mix(i):
			return true
	return false

func unstore() ->Movable:
	var temp = storedObject
	storedObject = null
	storedIngredient = null
	occupied = false
	if temp:
		temp.unhovered()
	return temp

func _process(_delta):
	if(passive):
		use(_delta)

func hovered():
	super.hovered()
	if storedObject:
		storedObject.hovered()
		
func unhovered():
	super.unhovered()
	if storedObject:
		storedObject.unhovered()

func _ready():
	if(obstacle):
		var navmesh = get_tree().get_first_node_in_group("navmesh")
		navmesh.addObstacle(self)
	if(storedObject):
		storedObject.pickUp(self)
	
