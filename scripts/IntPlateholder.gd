extends Interactible

class_name IntPlateholder
const instantiablePlate = preload("res://scenes/Plate.tscn")
@export var plateNbr:int = 4
var plateList = [] #### DOIT RAJOUTER UN FUTUREPLATELIST

func _enter_tree():
	taskType = Enum.TaskType.GENERATE
	add_to_group("Generator"+Enum.RecipeNames.keys()[Enum.RecipeNames.EmptyPlate])
	passive = true
	canBeOccupied = false
	for i in range(plateNbr):
		var inst = instantiablePlate.instantiate()
		inst.recipe = Enum.RecipeNames.EmptyPlate
		add_child(inst)
		inst.set_global_position(storePoint.global_position)
		inst.parent = self
		inst.parentOffset = Vector3(0, plateList.size() * 0.1, 0)
		plateList.append(inst)

func store(i:Movable) -> bool:
	if(plateList < 4 and i is Plate):
		i.parent.objectInHand = null
		i.pickUp(self)
		i.parentOffset = Vector3(0, plateList.size() * 0.1, 0)
		plateList.append(i)
	return false
	
func unstore() -> Movable:
	var inst = plateList[plateList.size()-1]
	plateList.erase(inst)
	inst.parentOffset = Vector3.ZERO
	return inst

func _process(_delta):
	super._process(_delta)
