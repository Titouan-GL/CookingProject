extends Interactible
class_name IntStove

@export var light:Light3D

func _init():
	taskType = Enum.TaskType.COOK
	passive = true

func _process(_delta):
	super._process(_delta)
	if storedObject and storedObject.inUse:
		light.visible = true
		light.light_energy = randf_range(0.9, 1.1)
	else:
		light.visible = false
		
