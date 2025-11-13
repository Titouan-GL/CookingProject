extends MovableStorage
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
	if(recipe == emptyName): #if pan is empty, we merge with it
		recipe = Recipes.recipesMix(recipe, i.recipe)
		i.queue_free()
		i.parent.objectInHand = null
	else: #if not we merge what is in the pan with the other ingredient
		i.mixRecipe(recipe)
		empty()
	UpdateAppearance()


func mix(i:Ingredient):
	store(i)

func _enter_tree():
	groupName = "PanEMPTY"
	emptyName = Enum.RecipeNames.EmptyPan
	progressMaxValues = {Enum.TaskType.COOK:3}
	super._enter_tree()
