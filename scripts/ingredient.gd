extends Movable
class_name Ingredient
@export var mesh:MeshInstance3D




func UpdateRecipe(newRecipe:Enum.RecipeNames):
	remove_from_group(Enum.RecipeNames.keys()[recipe])
	recipe = newRecipe
	add_to_group(Enum.RecipeNames.keys()[recipe])
	UpdateAppearance()


func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(progress.has(s) and progress[s] > 0):
		progress[s] -= delta
		progressBar.value = 1-(progress[s]/progressMaxValues[s])
		if(progress[s] <= 0):
			if(s == Enum.TaskType.CUT):
				cut()
			return true
	return false

func mix(i): #destroy the ingredient it's beeing mixed with
	if i is Ingredient:
		var newRecipe:Enum.RecipeNames = Recipes.recipesMix(recipe, i.recipe)
		if(newRecipe != Enum.RecipeNames.Empty):
			i.parent.objectInHand = null
			i.queue_free()
			UpdateRecipe(newRecipe)
	elif i is MovableStorage:
		i.store(self)
		

func mixRecipe(ingRecipe:Enum.RecipeNames):
	var newRecipe:Enum.RecipeNames = Recipes.recipesMix(recipe, ingRecipe)
	if(newRecipe != Enum.RecipeNames.Empty):
		UpdateRecipe(newRecipe)

func _enter_tree():
	super._enter_tree()
	progressMaxValues = {Enum.TaskType.CUT:3}
	progress = progressMaxValues.duplicate()
	prevProgress = progress.duplicate()
	add_to_group(Enum.RecipeNames.keys()[recipe])
	progressBar.visible = false
	UpdateAppearance()
	

func cut():
	var newRecipe = Recipes.recipesCut(recipe)
	if newRecipe != Enum.RecipeNames.Empty:
		UpdateRecipe(newRecipe)

func cook():
	UpdateRecipe(Recipes.recipesCook(recipe))

func _process(_delta):
	super._process(_delta)
