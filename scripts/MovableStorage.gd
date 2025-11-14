extends Movable

class_name MovableStorage


var groupName:String
var emptyName:Enum.RecipeNames

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()
	if(recipe == Enum.RecipeNames.Empty):
		recipe = emptyName
	UpdateAppearance()

func store(i:Ingredient):
	mixRecipe(i.recipe)
	i.parent.objectInHand = null
	i.queue_free()

func mix(i:Ingredient): 
	store(i)

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
