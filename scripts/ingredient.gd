extends Movable
class_name Ingredient
@export var mesh:MeshInstance3D

var progress = {Enum.TaskType.CUT:1}


func UpdateRecipe(newRecipe:Enum.RecipeNames):
	remove_from_group(Enum.RecipeNames.keys()[recipe])
	recipe = newRecipe
	add_to_group(Enum.RecipeNames.keys()[recipe])
	UpdateAppearance()

	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(progress.has(s)):
		progress[s] -= delta
		if(progress[s] <= 0):
			if(s == Enum.TaskType.CUT):
				cut()
			return true
	return false

func mix(ing:Ingredient): #destroy the ingredients it's beeing mixed with
	var newRecipe:Enum.RecipeNames = Recipes.recipesMix(recipe, ing.recipe)
	if(newRecipe != Enum.RecipeNames.Empty):
		ing.parent.objectInHand = null
		ing.queue_free()
		UpdateRecipe(newRecipe)

func mixRecipe(ingRecipe:Enum.RecipeNames):
	var newRecipe:Enum.RecipeNames = Recipes.recipesMix(recipe, ingRecipe)
	if(newRecipe != Enum.RecipeNames.Empty):
		UpdateRecipe(newRecipe)

func _enter_tree():
	super._enter_tree()
	add_to_group(Enum.RecipeNames.keys()[recipe])
	UpdateAppearance()

func cut():
	UpdateRecipe(Recipes.recipesCut(recipe))

func cook():
	UpdateRecipe(Recipes.recipesCook(recipe))

func _process(_delta):
	super._process(_delta)
