extends Movable

class_name MovableStorage


var groupName:String
var emptyName:Enum.RecipeNames
@export var canBeStored:Array[Enum.RecipeNames]

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()
	if(recipe == Enum.RecipeNames.Empty):
		recipe = emptyName
	UpdateAppearance()

func store(i:Ingredient) -> bool:
	if(i.recipe in canBeStored):
		mixRecipe(i.recipe)
		if i.parent is Cook:
			i.parent.objectInHand = null
		elif i.parent is Interactible:
			i.parent.storedObject = null
		i.queue_free()
		return true
	return false

func mix(i): 
	if i is Ingredient:
		if Recipes.recipesMix(i.recipe, recipe) != Enum.RecipeNames.Empty:
			store(i)
	elif i is Enum.RecipeNames:
		if Recipes.recipesMix(i, recipe) != Enum.RecipeNames.Empty:
			mixRecipe(i)
	elif i is MovableStorage:
		if Recipes.recipesMix(i.recipe, recipe) != Enum.RecipeNames.Empty:
			if(task.object.emptyName in Recipes.getRecipePrimaryIngredients(Recipes.recipesMix(task.destination.recipe, task.object.recipe))):
				task.object.mixRecipe(task.destination.empty())
			else:
				if(task.object.recipe == task.object.emptyName):
					task.object.mixRecipe(task.destination.empty())
				else:
					task.destination.mixRecipe(task.object.empty())

func mixRecipe(r:Enum.RecipeNames):
	var newRecipe = Recipes.recipesMix(recipe, r)
	if(newRecipe == Enum.RecipeNames.Empty):
		recipe = r
	else:
		recipe = newRecipe
	UpdateAppearance()
	
func empty() -> Enum.RecipeNames:
	var prevRecipe = recipe
	occupied = false
	add_to_group(groupName)
	recipe = emptyName
	progress = progressMaxValues.duplicate()
	prevProgress = progressMaxValues.duplicate()
	UpdateAppearance()
	return prevRecipe
	
func cook():
	recipe = Recipes.recipesCook(recipe)
	UpdateAppearance()
