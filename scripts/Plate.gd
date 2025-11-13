extends MovableStorage
class_name Plate


func UpdateAppearance():
	if(recipe != Enum.RecipeNames.EmptyPlate):
		var newMesh = Recipes.recipeToPlateMesh(recipe)
		if(visibleMesh) : visibleMesh.queue_free()
		if(newMesh):
			visibleMesh = newMesh.instantiate()
			add_child(visibleMesh)
			visibleMesh.set_position(Vector3.ZERO)

func addProgress(_s:Enum.TaskType, _delta:float) -> bool:
	return false


func store(i:Ingredient):
	recipe = i.recipe
	i.queue_free()
	i.parent.objectInHand = null
	UpdateAppearance()


func mix(i:Ingredient):
	store(i)

func _enter_tree():
	groupName = "EmptyPlate"
	emptyName = Enum.RecipeNames.EmptyPlate
	super._enter_tree()
