class_name Recipes

const meshes:Dictionary = {
	Enum.RecipeNames.Tom : preload("res://assets/blender/Recipes/Tomato.blend"),
	Enum.RecipeNames.CutTom : preload("res://assets/blender/Recipes/CutTomato.blend"),
	Enum.RecipeNames.PotCutTom : preload("res://assets/blender/Recipes/TomSoup1.blend"),
	Enum.RecipeNames.PotCutTomCutTom : preload("res://assets/blender/Recipes/TomSoup2.blend"),
	Enum.RecipeNames.PotCutTomCutTomCutTom : preload("res://assets/blender/Recipes/TomSoup3.blend"),
	Enum.RecipeNames.PotTomatoSoup : preload("res://assets/blender/Recipes/TomSoup.blend"),
	Enum.RecipeNames.Ste: preload("res://assets/blender/Recipes/Raw_steack.blend"), 
	Enum.RecipeNames.CutSte: preload("res://assets/blender/Recipes/CutSteak.blend"), 
	Enum.RecipeNames.PanCutSte: preload("res://assets/blender/Recipes/CutSteak.blend"), 
	Enum.RecipeNames.PanCookCutSte: preload("res://assets/blender/Recipes/CookCutSteak.blend"), 
	Enum.RecipeNames.Sal: preload("res://assets/blender/Recipes/Salad.blend"), 
	Enum.RecipeNames.CutSal: preload("res://assets/blender/Recipes/CutSalad.blend"), 
	Enum.RecipeNames.Bur: preload("res://assets/blender/Recipes/BurgerBread.blend"), 
	Enum.RecipeNames.BurSal: preload("res://assets/blender/Recipes/BurgSal.blend"), 
	Enum.RecipeNames.BurSte: preload("res://assets/blender/Recipes/BurgSte.blend"), 
	Enum.RecipeNames.BurSteSal: preload("res://assets/blender/Recipes/BurgSalSte.blend"),
	Enum.RecipeNames.BurSteTom: preload("res://assets/blender/Recipes/BurgSteTom.blend"),
	Enum.RecipeNames.BurSteSalTom: preload("res://assets/blender/Recipes/BurgSteSalTom.blend"),
	Enum.RecipeNames.BurSalTom: preload("res://assets/blender/Recipes/BurgSalTom.blend"),
	Enum.RecipeNames.BurTom: preload("res://assets/blender/Recipes/BurgTom.blend"),
	Enum.RecipeNames.CutTomCutSal: preload("res://assets/blender/Recipes/CutTomCutSal.blend"),
	Enum.RecipeNames.TomatoSoup : preload("res://assets/blender/Recipes/TomSoupPlate.blend"),
	Enum.RecipeNames.SteSalTom : preload("res://assets/blender/Recipes/SteSalTom.blend"),
	Enum.RecipeNames.SteSal : preload("res://assets/blender/Recipes/SteSal.blend"),
}

const meshesInPlateOverride:Dictionary = {
}

const textures:Dictionary = {
	Enum.RecipeNames.TomatoSoup : preload("res://assets/textures/TomatoSoupIcon.png"),
	Enum.RecipeNames.BurSteSal: preload("res://assets/textures/burgerIcon.png"),
	Enum.RecipeNames.CutTomCutSal: preload("res://assets/textures/TomatoSaladIcon.png"),
	Enum.RecipeNames.BurSteSalTom: preload("res://assets/textures/BurgSteSalTomIcon.png"),
}

const recipes:Dictionary[Enum.RecipeNames, Array] = { #array where 0 is the tasktype and 1 is an dictionary of recipes
	Enum.RecipeNames.EmptyPot: [Enum.TaskType.INITAL_MIXER, {}],
	Enum.RecipeNames.EmptyPlate: [Enum.TaskType.GENERATE_PLATE, {}],
	Enum.RecipeNames.EmptyPan: [Enum.TaskType.INITAL_MIXER, {}],
	Enum.RecipeNames.Tom: [Enum.TaskType.GENERATE_TOMATO, {}],
	Enum.RecipeNames.CutTom: [Enum.TaskType.CUT, {Enum.RecipeNames.Tom:1}],
	Enum.RecipeNames.PotCutTom: [Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:1, Enum.RecipeNames.EmptyPot:1}],
	Enum.RecipeNames.PotCutTomCutTom: [Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:2, Enum.RecipeNames.EmptyPot:1}],
	Enum.RecipeNames.PotCutTomCutTomCutTom: [Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:3, Enum.RecipeNames.EmptyPot:1}],
	Enum.RecipeNames.PotTomatoSoup: [Enum.TaskType.COOK, {Enum.RecipeNames.PotCutTomCutTomCutTom:1}],
	Enum.RecipeNames.TomatoSoup: [Enum.TaskType.MIX, {Enum.RecipeNames.PotTomatoSoup:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.Bur: [Enum.TaskType.GENERATE_BURGER, {}],
	Enum.RecipeNames.Ste: [Enum.TaskType.GENERATE_STEAK, {}],
	Enum.RecipeNames.CutSte: [Enum.TaskType.CUT, {Enum.RecipeNames.Ste:1}],
	Enum.RecipeNames.PanCutSte: [Enum.TaskType.MIX, {Enum.RecipeNames.CutSte:1, Enum.RecipeNames.EmptyPan:1}],
	Enum.RecipeNames.PanCookCutSte: [Enum.TaskType.COOK, {Enum.RecipeNames.PanCutSte:1}],
	Enum.RecipeNames.Sal: [Enum.TaskType.GENERATE_SALAD, {}],
	Enum.RecipeNames.CutSal: [Enum.TaskType.CUT, {Enum.RecipeNames.Sal:1}],
	Enum.RecipeNames.BurSal:[Enum.TaskType.MIX, {Enum.RecipeNames.CutSal:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurTom:[Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurSte:[Enum.TaskType.MIX, {Enum.RecipeNames.PanCookCutSte:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurSalTom:[Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurSteSal:[Enum.TaskType.MIX, {Enum.RecipeNames.PanCookCutSte:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurSteTom:[Enum.TaskType.MIX, {Enum.RecipeNames.PanCookCutSte:1, Enum.RecipeNames.CutTom:1, Enum.RecipeNames.Bur:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.BurSteSalTom:[Enum.TaskType.MIX, {Enum.RecipeNames.Bur:1, Enum.RecipeNames.CutTom:1, Enum.RecipeNames.PanCookCutSte:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.CutTomCutSal:[Enum.TaskType.MIX, {Enum.RecipeNames.CutTom:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.SteSal:[Enum.TaskType.MIX, {Enum.RecipeNames.CutSte:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.SteTom:[Enum.TaskType.MIX, {Enum.RecipeNames.CutSte:1, Enum.RecipeNames.CutTom:1, Enum.RecipeNames.EmptyPlate:1}],
	Enum.RecipeNames.SteSalTom:[Enum.TaskType.MIX, {Enum.RecipeNames.CutSte:1, Enum.RecipeNames.CutSal:1, Enum.RecipeNames.CutTom:1, Enum.RecipeNames.EmptyPlate:1}],
}

const scores:Dictionary[Enum.RecipeNames, int] = { 
	Enum.RecipeNames.TomatoSoup: 200,
	Enum.RecipeNames.CutTomCutSal: 130,
	Enum.RecipeNames.BurSteSal: 200,
	Enum.RecipeNames.BurSteSalTom: 240,
}


static func getScore(recipe:Enum.RecipeNames):
	if(recipe in scores.keys()):
		return scores[recipe]
	else:
		return -100


static func getRecipePrimaryIngredients(recipe:Enum.RecipeNames, nb:int = 1):
	var arr = {}
	if(recipe in recipes.keys() and recipes[recipe][0] == Enum.TaskType.MIX):
		for r in recipes[recipe][1]:
			arr = add_dictionary(arr, getRecipePrimaryIngredients(r, recipes[recipe][1][r]))
		return arr
	else:
		return {recipe:nb}

static func add_dictionary(dict_a: Dictionary, dict_b: Dictionary):
	for key in dict_b.keys():
		if key in dict_a:
			dict_a[key] += dict_b[key]
		else:
			dict_a[key] = dict_b[key]
	return dict_a

static func subtract_dictionary(dict_a: Dictionary, dict_b: Dictionary):
	for key in dict_b.keys():
		if key in dict_a:
			dict_a[key] -= dict_b[key]
			if dict_a[key] <= 0:
				dict_a.erase(key)
	return dict_a

static func dict_contains_keys(dict_a: Dictionary, dict_b: Dictionary) -> bool:
	for key in dict_b.keys():
		if not dict_a.has(key):
			return false
	return true
	


static func getNeeded(recipe:Enum.RecipeNames) -> Dictionary: #dictionary of recipes
	if(recipe in recipes.keys()):
		return recipes[recipe][1]
	else:
		return {}

static func getTaskType(recipe:Enum.RecipeNames) -> Enum.TaskType:
	if(recipe in recipes.keys()):
		return recipes[recipe][0]
	else:
		return Enum.TaskType.NONE

static func recipeToMesh(recipe:Enum.RecipeNames) -> PackedScene:
	if(meshes.has(recipe)): return meshes[recipe]
	return null

static func recipeToPlateMesh(recipe:Enum.RecipeNames) -> PackedScene:
	if(meshesInPlateOverride.has(recipe)): return meshesInPlateOverride[recipe]
	if(meshes.has(recipe)): return meshes[recipe]
	return null

static func recipeToTexture(recipe:Enum.RecipeNames) -> CompressedTexture2D:
	if(textures.has(recipe)): return textures[recipe]
	return null

static func recipesMix(recipe:Enum.RecipeNames, ingredient:Enum.RecipeNames, first:bool = true) -> Enum.RecipeNames:
	match recipe:
		Enum.RecipeNames.PanCookCutSte:
			match ingredient:
				Enum.RecipeNames.CutTomCutSal:
					return Enum.RecipeNames.SteSalTom
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.SteSal
		Enum.RecipeNames.EmptyPlate:
			match ingredient:
				Enum.RecipeNames.PotTomatoSoup:
					return Enum.RecipeNames.TomatoSoup
		Enum.RecipeNames.Bur:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSal
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.BurTom
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSte
				Enum.RecipeNames.CutTomCutSal:
					return Enum.RecipeNames.BurSalTom
		Enum.RecipeNames.BurSte:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSteSal
		Enum.RecipeNames.BurSteTom:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSteSalTom
		Enum.RecipeNames.BurSal:
			match ingredient:
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSteSal
				Enum.RecipeNames.CutTom:
					return Enum.RecipeNames.BurSalTom
		Enum.RecipeNames.BurTom:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSalTom
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSteTom
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
		Enum.RecipeNames.EmptyPan:
			match ingredient:
				Enum.RecipeNames.CutSte:
					return Enum.RecipeNames.PanCutSte
		Enum.RecipeNames.Empty:
			return ingredient
		Enum.RecipeNames.CutTom:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.CutTomCutSal
				Enum.RecipeNames.BurSteSal:
					return Enum.RecipeNames.BurSteSalTom
				Enum.RecipeNames.BurSal:
					return Enum.RecipeNames.BurSalTom
		Enum.RecipeNames.BurSalTom:
			match ingredient:
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSteSalTom
	if(first): #on explore dans l'autre sens
		return recipesMix(ingredient, recipe, false)
	
	if(recipe != Enum.RecipeNames.EmptyPlate and ingredient != Enum.RecipeNames.EmptyPlate):
		printerr("pas de recette trouvée pour ", Enum.RecipeNames.keys()[recipe], " et ", Enum.RecipeNames.keys()[ingredient])
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
	

static func recipesCook(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.PotCutTomCutTomCutTom:
			return Enum.RecipeNames.PotTomatoSoup
		Enum.RecipeNames.PanCutSte:
			return Enum.RecipeNames.PanCookCutSte
	return Enum.RecipeNames.Empty
	
