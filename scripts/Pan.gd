extends MovableCooker
class_name Pan

	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.PanCutSte):
		if(progress.has(s)):
			progress[s] -= delta
			progressBar.value = 1-(progress[s]/progressMaxValues[s])
			if(progress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					cook()
				return true
	return false

func canEmpty()->bool:
	return recipe == Enum.RecipeNames.PanCookCutSte

func store(i:Ingredient):
	i.parent.objectInHand = null
	if(recipe == emptyName):
		recipe = Recipes.recipesPot(i.recipe)
		i.queue_free()
	else:
		i.recipe = Recipes.recipesMix(recipe, i.recipe)
		i.UpdateAppearance()
		empty()
	UpdateAppearance()


func mix(i:Ingredient): 
	store(i)

func _enter_tree():
	groupName = "PanEMPTY"
	emptyName = Enum.RecipeNames.EmptyPan
	progressMaxValues = {Enum.TaskType.COOK:3}
	super._enter_tree()
