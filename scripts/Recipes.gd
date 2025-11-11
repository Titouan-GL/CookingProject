class_name Recipes

const meshes:Dictionary = {
	Enum.RecipeNames.Tom : preload("res://assets/blender/Recipes/Tomato.blend"),
	Enum.RecipeNames.CutTom : preload("res://assets/blender/Recipes/CutTomato.blend"),
	Enum.RecipeNames.PotCutTom : preload("res://assets/blender/Recipes/TomSoup1.blend"),
	Enum.RecipeNames.PotCutTomCutTom : preload("res://assets/blender/Recipes/TomSoup2.blend"),
	Enum.RecipeNames.PotCutTomCutTomCutTom : preload("res://assets/blender/Recipes/TomSoup3.blend"),
	Enum.RecipeNames.TomatoSoup : preload("res://assets/blender/Recipes/TomSoup.blend"),
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
	Enum.RecipeNames.BurSteSalTom: preload("res://assets/blender/Recipes/BurgSteSalTom.blend"),
	Enum.RecipeNames.BurSalTom: preload("res://assets/blender/Recipes/BurgSalTom.blend"),
	Enum.RecipeNames.CutTomCutSal: preload("res://assets/blender/Recipes/CutTomCutSal.blend"),
}

const textures:Dictionary = {
	Enum.RecipeNames.TomatoSoup : preload("res://assets/textures/TomatoSoupIcon.png"),
	Enum.RecipeNames.BurSteSal: preload("res://assets/textures/burgerIcon.png"),
	Enum.RecipeNames.CutTomCutSal: preload("res://assets/textures/TomatoSaladIcon.png"),
	Enum.RecipeNames.BurSteSalTom: preload("res://assets/textures/BurgSteSalTomIcon.png"),
}

const recipes:Dictionary[Enum.RecipeNames, Array] = { #array where 0 is the tasktype and 1 is an array of recipes
	Enum.RecipeNames.EmptyPot: [Enum.TaskType.INITAL_MIXER, []],
	Enum.RecipeNames.Tom: [Enum.TaskType.GENERATE_TOMATO, []],
	Enum.RecipeNames.CutTom: [Enum.TaskType.CUT, [Enum.RecipeNames.Tom]],
	Enum.RecipeNames.PotCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.EmptyPot]],
	Enum.RecipeNames.PotCutTomCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTom]],
	Enum.RecipeNames.PotCutTomCutTomCutTom: [Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTomCutTom]],
	Enum.RecipeNames.TomatoSoup: [Enum.TaskType.COOK, [Enum.RecipeNames.PotCutTomCutTomCutTom]],
	Enum.RecipeNames.EmptyPan: [Enum.TaskType.INITAL_MIXER, []],
	Enum.RecipeNames.Bur: [Enum.TaskType.GENERATE_BURGER, []],
	Enum.RecipeNames.Ste: [Enum.TaskType.GENERATE_STEAK, []],
	Enum.RecipeNames.CutSte: [Enum.TaskType.CUT, [Enum.RecipeNames.Ste]],
	Enum.RecipeNames.PanCutSte: [Enum.TaskType.MIX, [Enum.RecipeNames.CutSte, Enum.RecipeNames.EmptyPan]],
	Enum.RecipeNames.PanCookCutSte: [Enum.TaskType.COOK, [Enum.RecipeNames.PanCutSte]],
	Enum.RecipeNames.Sal: [Enum.TaskType.GENERATE_SALAD, []],
	Enum.RecipeNames.CutSal: [Enum.TaskType.CUT, [Enum.RecipeNames.Sal]],
	Enum.RecipeNames.BurSal:[Enum.TaskType.MIX, [Enum.RecipeNames.CutSal, Enum.RecipeNames.Bur]],
	Enum.RecipeNames.BurSte:[Enum.TaskType.MIX, [Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.Bur]],
	Enum.RecipeNames.BurSteSal:[Enum.TaskType.MIX, [Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.BurSal]],
	Enum.RecipeNames.BurSteTom:[Enum.TaskType.MIX, [Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.BurTom]],
	Enum.RecipeNames.BurSteSalTom:[Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.BurSteSal]],
	Enum.RecipeNames.CutTomCutSal:[Enum.TaskType.MIX, [Enum.RecipeNames.CutTom, Enum.RecipeNames.CutSal]]
}

const decomposition:Dictionary[Enum.RecipeNames, Array] = { 
	Enum.RecipeNames.PotCutTom: [Enum.RecipeNames.CutTom, Enum.RecipeNames.EmptyPot],
	Enum.RecipeNames.PotCutTomCutTom: [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTom],
	Enum.RecipeNames.PotCutTomCutTomCutTom: [Enum.RecipeNames.CutTom, Enum.RecipeNames.PotCutTomCutTom],
	Enum.RecipeNames.PanCutSte: [Enum.RecipeNames.CutSte, Enum.RecipeNames.EmptyPan],
	Enum.RecipeNames.BurSal:[Enum.RecipeNames.CutSal, Enum.RecipeNames.Bur],
	Enum.RecipeNames.BurSte:[Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.Bur],
	Enum.RecipeNames.BurSteSal:[Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.BurSal],
	Enum.RecipeNames.BurSteTom:[Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.BurTom],
	Enum.RecipeNames.BurSteSalTom:[Enum.RecipeNames.CutTom, Enum.RecipeNames.PanCookCutSte, Enum.RecipeNames.CutSal],
	Enum.RecipeNames.CutTomCutSal:[Enum.RecipeNames.CutTom, Enum.RecipeNames.CutSal]
}

static func getRecipeBinary(recipe:Enum.RecipeNames):
	var bit_array = PackedByteArray()
	@warning_ignore("integer_division")
	bit_array.resize(8+Enum.RecipeNames.size()/8)
	if(recipe in decomposition.keys()):
		for r in decomposition[recipe]:
			add_packed_byte_arrays(bit_array,getRecipeBinary(r))
		return bit_array
	else:
		set_bit(bit_array, recipe, 1)
		return bit_array

static func packed_bytes_to_binary(pba: PackedByteArray, little_endian := true) -> String:
	var bits := ""
	
	if little_endian:
		for i in range(pba.size() - 1, -1, -1):
			bits += "%08b" % pba[i]
	else:
		for i in range(pba.size()):
			bits += "%08b" % pba[i]
	return bits

static func add_packed_byte_arrays(a: PackedByteArray, b: PackedByteArray) -> PackedByteArray:
	var result := PackedByteArray()
	var max_len = max(a.size(), b.size())
	result.resize(max_len)
	var carry := 0
	for i in range(max_len):
		var byte_a = a[i] if i < a.size() else 0
		var byte_b = b[i] if i < b.size() else 0
		var sum = byte_a + byte_b + carry
		result[i] = sum & 0xFF
		carry = sum >> 8
	if carry != 0:
		result.append(carry)
	return result

static func set_bit(bit_array:PackedByteArray, bit_index: int, value: bool):
	@warning_ignore("integer_division")
	var byte_index = bit_index / 8
	var bit_offset = bit_index % 8
	var byte_val = bit_array[byte_index]
	if value:
		byte_val |= 1 << bit_offset
	else:
		byte_val &= ~(1 << bit_offset)
	bit_array[byte_index] = byte_val

static func get_bit(bit_array:PackedByteArray, bit_index: int) -> bool:
	@warning_ignore("integer_division")
	var byte_index = bit_index / 8
	var bit_offset = bit_index % 8
	return (bit_array[byte_index] & (1 << bit_offset)) != 0

static func getAllNeeded(recipe:Enum.RecipeNames) -> Array: #array of recipes
	if(recipe in recipes.keys()):
		var returning = []
		for i in range(1, recipes[recipe].size(), 1):
			returning.append(recipes[recipe][i])
		return returning
	else:
		return []

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

static func recipeToTexture(recipe:Enum.RecipeNames) -> CompressedTexture2D:
	if(textures.has(recipe)): return textures[recipe]
	return null

static func recipesMix(recipe:Enum.RecipeNames, ingredient:Enum.RecipeNames, first:bool = true) -> Enum.RecipeNames:
	match recipe:
		Enum.RecipeNames.Bur:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSal
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSte
		Enum.RecipeNames.BurSte:
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.BurSteSal
		Enum.RecipeNames.BurSal:
			match ingredient:
				Enum.RecipeNames.PanCookCutSte:
					return Enum.RecipeNames.BurSteSal
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
		Enum.RecipeNames.CutTom:
			print(Enum.RecipeNames.keys()[ingredient])
			match ingredient:
				Enum.RecipeNames.CutSal:
					return Enum.RecipeNames.CutTomCutSal
				Enum.RecipeNames.BurSteSal:
					return Enum.RecipeNames.BurSteSalTom
				Enum.RecipeNames.BurSal:
					return Enum.RecipeNames.BurSalTom
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
		Enum.RecipeNames.CutSte:
			return Enum.RecipeNames.PanCutSte
	return Enum.RecipeNames.Empty

static func recipesCook(ingredient:Enum.RecipeNames) -> Enum.RecipeNames:
	match ingredient:
		Enum.RecipeNames.PotCutTomCutTomCutTom:
			return Enum.RecipeNames.TomatoSoup
		Enum.RecipeNames.PanCutSte:
			return Enum.RecipeNames.PanCookCutSte
	return Enum.RecipeNames.Empty
	
