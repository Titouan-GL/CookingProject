extends Character

class_name Cook

var objectInHand:Movable
@export var dishesSpeed:float = -1
@export var cuttingSpeed:float = -1
@export var mixingProficiency:float = -1
@export var servingProficiency:float = -1
@export var storePoint: Node3D


func pickUp(obj:Movable):
	if(objectInHand):
		objectInHand.dropped()
	if obj :
		obj.pickUp(self)
		obj.global_position = Vector3(storePoint.global_position)
		obj.global_rotation = Vector3(storePoint.global_rotation)
		objectInHand = obj

func dropObject():
	objectInHand.dropped()
	objectInHand = null
