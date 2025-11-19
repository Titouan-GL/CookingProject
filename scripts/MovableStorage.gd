extends Movable

class_name MovableStorage


var groupName:String
var emptyName:Enum.RecipeNames
@export var canBeStored:Array[Enum.RecipeNames]
var availableForStorage = true
var dirty = false

func _enter_tree():
	super._enter_tree()
	add_to_group(groupName)
	progress = progressMaxValues.duplicate()
	if(recipe == Enum.RecipeNames.Empty):
		recipe = emptyName
	UpdateAppearance()

func store(i:Ingredient) -> bool:
	if(i.recipe in canBeStored and availableForStorage):
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
		if not (dirty or i.dirty):
			if Recipes.recipesMix(i.recipe, recipe) not in [Enum.RecipeNames.Empty, emptyName, i.emptyName] :
				var mixed = Recipes.getRecipePrimaryIngredients(Recipes.recipesMix(i.recipe, recipe))
				if(emptyName in mixed):
					mixRecipe(i.empty())
				elif(i.emptyName in mixed):
					i.mixRecipe(empty())
				elif(self is Plate):
					mixRecipe(i.empty())
				elif(i is Plate):
					i.mixRecipe(empty())
				

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
