extends Movable

class_name MovableStorage


var groupName:String
var emptyName:Enum.RecipeNames

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()
	recipe = emptyName

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
