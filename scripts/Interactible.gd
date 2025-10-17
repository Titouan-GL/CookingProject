extends Node3D

class_name Interactible
@export var storePoint:Node3D
@export var storedObject:Movable
var taskType:Enum.TaskType
var storedIngredient:Ingredient
var progressSpeed:float = 1
var passive:bool
var occupied:bool = false
var canBeOccupied:bool = true

func _enter_tree():
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
	return false

func unStore() ->Movable:
	var temp = storedObject
	storedObject = null
	storedIngredient = null
	occupied = false
	return temp

func _process(_delta):
	if(passive):
		use(_delta)

func _ready():
	if(storedObject):
		storedObject.pickUp(self)
