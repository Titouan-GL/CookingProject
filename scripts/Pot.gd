extends MovableCooker
class_name Pot
@export var mesh:MeshInstance3D

	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.PotCutTomCutTomCutTom):
		if(currentProgress.has(s)):
			currentProgress[s] -= delta
			if(currentProgress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					cook()
				return true
	return false

func canEmpty()->bool:
	return recipe == Enum.RecipeNames.TomatoSoup

func store(i:Ingredient):
	i.parent.objectInHand = null
	if(recipe == emptyName):
		recipe = Recipes.recipesPot(i.recipe)
	else:
		recipe = Recipes.recipesMix(recipe, i.recipe)
		if(recipe == Enum.RecipeNames.PotCutTomCutTomCutTom):
			remove_from_group(groupName)
	i.queue_free()
	UpdateAppearance()

func mix(i:Ingredient): 
	store(i)

func _enter_tree():
	groupName = "PotEMPTY"
	emptyName = Enum.RecipeNames.EmptyPot
	progressMaxValues = {Enum.TaskType.COOK:1}
	super._enter_tree()
