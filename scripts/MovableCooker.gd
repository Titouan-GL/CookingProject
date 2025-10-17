extends Movable

class_name MovableCooker


var progressMaxValues:Dictionary
var currentProgress:Dictionary
var groupName:String
var emptyName:Enum.RecipeNames

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	currentProgress = progressMaxValues.duplicate()
	recipe = emptyName

func empty() -> Enum.RecipeNames:
	var prevRecipe = recipe
	occupied = false
	add_to_group(groupName)
	recipe = emptyName
	currentProgress = progressMaxValues.duplicate()
	UpdateAppearance()
	return prevRecipe
	
func cook():
	recipe = Recipes.recipesCook(recipe)
	UpdateAppearance()
