extends MovableStorage
class_name Plate

var eatenOn = false
var needed = false
@export var dirt:Node3D

func UpdateAppearance():
	if(visibleMesh):
		visibleMesh.queue_free()
	if(recipe != Enum.RecipeNames.EmptyPlate):
		var newMesh = Recipes.recipeToPlateMesh(recipe)
		if(newMesh):
			visibleMesh = newMesh.instantiate()
			add_child(visibleMesh)
			visibleMesh.set_position(Vector3.ZERO)
			findMeshInstances(visibleMesh)
			if ishovered : 
				unhovered()
				hovered()

func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(progress.has(s) and dirty):
		progress[s] -= delta
		progressBar.value = 1-(progress[s]/progressMaxValues[s])
		if(progress[s] <= 0):
			if(s == Enum.TaskType.CLEAN):
				cleaned()
			return true
	return false

func served():
	remove_from_group("movable")
	remove_from_group(groupName)
	eatenOn = true
	
func mealFinished():
	recipe = emptyName
	eatenOn = false
	dirt.visible = true
	dirty = true
	add_to_group("dirtyPlate")
	availableForStorage = false
	UpdateAppearance()

func cleaned():
	dirt.visible = false
	dirty = false
	availableForStorage = true
	remove_from_group("dirtyPlate")
	add_to_group("movable")
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()

func stored():
	remove_from_group("movable")
	remove_from_group(groupName)
	
func unstored():
	add_to_group("movable")
	add_to_group(groupName)


func setNeeded(v:bool):
	needed = v

func _process(_delta):
	super._process(_delta)
	#print(get_groups(), " " , needed)

func empty() -> Enum.RecipeNames:
	var prevRecipe = recipe
	recipe = emptyName
	UpdateAppearance()
	return prevRecipe

func _enter_tree():
	groupName = "EmptyPlate"
	emptyName = Enum.RecipeNames.EmptyPlate
	progressMaxValues = {Enum.TaskType.CLEAN:3}
	super._enter_tree()

func _ready():
	super._ready()
	for i in Enum.RecipeNames.values():
		canBeStored.append(i)
	if(parent is IntPlateholder):
		remove_from_group("movable")
		remove_from_group(groupName)
