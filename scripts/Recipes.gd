class_name Recipes

const meshes:Dictionary = {
	Enum.RecipeNames.Tom : preload("res://assets/blender/Tomato.blend"),
	Enum.RecipeNames.CutTom : preload("res://assets/blender/CutTomato.blend"),
	Enum.RecipeNames.PotCutTom : preload("res://assets/blender/TomSoup1.blend"),
	Enum.RecipeNames.PotCutTomCutTom : preload("res://assets/blender/TomSoup2.blend"),
	Enum.RecipeNames.PotCutTomCutTomCutTom : preload("res://assets/blender/TomSoup3.blend"),
	Enum.RecipeNames.TomatoSoup : preload("res://assets/blender/TomSoup.blend"),
	Enum.RecipeNames.Ste: preload("res://assets/blender/Raw_steack.blend"), 
	Enum.RecipeNames.CutSte: preload("res://assets/blender/CutSteak.blend"), 
	Enum.RecipeNames.CookCutSte: preload("res://assets/blender/CookCutSteak.blend"), 
	Enum.RecipeNames.Sal: preload("res://assets/blender/Salad.blend"), 
	Enum.RecipeNames.CutSal: preload("res://assets/blender/CutSalad.blend"), 
	Enum.RecipeNames.Bur: preload("res://assets/blender/BurgerBread.blend"), 
	Enum.RecipeNames.BurSal: preload("res://assets/blender/BurgSal.blend"), 
	Enum.RecipeNames.BurSte: preload("res://assets/blender/BurgSte.blend"), 
	Enum.RecipeNames.Burger: preload("res://assets/blender/BurgSalSte.blend")
}

const recipes:Dictionary[Enum.RecipeNames, Array] = { #array where 0 is the tasktype and 1 is an array of recipes
	Enum.RecipeNames.Tom: [Enum.TaskType.GENERATE_TOMATO, []],
	Enum.RecipeNames.CutTom: [Enum.TaskType.CUT, [Enum.RecipeNames.Tom]],
	Enum.RecipeNames.PotCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.EmptyPot]],
	Enum.RecipeNames.PotCutTomCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTom]],
	Enum.RecipeNames.PotCutTomCutTomCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTomCutTom]],
	Enum.RecipeNames.TomatoSoup: [Enum.TaskType.COOK, [Enum.RecipeNames.PotCutTomCutTomCutTom]],
}

static func getNeeded(recipe:Enum.RecipeNames) -> Array: #array of recipes
	if(recipe in recipes.keys()):
		return recipes[recipe][1]
	else:
		return []

static func getTaskType(recipe:Enum.RecipeNames) -> Enum.TaskType:
	if(recipe in recipes.keys()):
		return recipes[recipe][0]
	else:
		return Enum.TaskType.NONE

static func recipeToMesh(recipe:Enum.RecipeNames) -> PackedScene:
	if(meshes.has(recipe)): return meshes[recipe]
	return null

static func recipesMix(recipe:Enum.RecipeNames, ingredient:Enum.RecipeNames, first:bool = true) -> Enum.RecipeNames:
	match recipe:
		Enum.RecipeNames.Bur:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSal
				Enum.RecipeNames.CookCutSte:
					return Enum.RecipeNames.BurSte
		Enum.RecipeNames.BurSte:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.Burger
		Enum.RecipeNames.BurSal:
			match ingredient:
				Enum.RecipeNames.CookCutSte:
					return Enum.RecipeNames.Burger
		Enum.RecipeNames.PotCutTom:
			match ingredient:
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.PotCutTomCutTom
		Enum.RecipeNames.PotCutTomCutTom:
			match ingredient:
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.PotCutTomCutTomCutTom
		Enum.RecipeNames.EmptyPot:
			match ingredient:
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.PotCutTom
		Enum.RecipeNames.Empty:
			return ingredient
	if(first):
		return recipesMix(ingredient, recipe, false)
	return Enum.RecipeNames.Empty

static func recipesCut(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.Tom:
			return Enum.RecipeNames.CutTom
		Enum.RecipeNames.Sal:
			return Enum.RecipeNames.CutSal
		Enum.RecipeNames.Ste:
			return Enum.RecipeNames.CutSte
	return Enum.RecipeNames.Empty
	
static func recipesPot(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.CutTom:
			return Enum.RecipeNames.PotCutTom
	return Enum.RecipeNames.Empty

static func recipesCook(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.PotCutTomCutTomCutTom:
			return Enum.RecipeNames.TomatoSoup
		Enum.RecipeNames.CutSte:
			return Enum.RecipeNames.CookCutSte
	return Enum.RecipeNames.Empty
	
