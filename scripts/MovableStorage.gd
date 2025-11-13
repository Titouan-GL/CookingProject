extends Movable

class_name MovableStorage


var groupName:String
var emptyName:Enum.RecipeNames

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()
	recipe = emptyName

func store(i:Ingredient):
	var newRecipe = Recipes.recipesMix(recipe, i.recipe)
	if(newRecipe == Enum.RecipeNames.Empty):
		recipe = i.recipe
	else:
		recipe = newRecipe
	i.parent.objectInHand = null
	i.queue_free()
	UpdateAppearance()

func mix(i:Ingredient): 
	store(i)

func mixRecipe(r:Enum.RecipeNames):
	recipe = Recipes.recipesMix(recipe, r)
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
