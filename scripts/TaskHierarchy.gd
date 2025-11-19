extends Node3D
class_name Hierarchy

var AgentList:Array[Agent]
var MovableList:Array[Movable]
var DirtyPlateList:Array[Movable]
var RecipeNeededList:Array[Enum.RecipeNames]
var servePoints:Array = []
var printNewFrame = false

func findAgentClosestToObj(obj:Node3D) -> Cook:
	if(obj is Movable):
		if(obj.parent is Cook):
			return obj.parent
		if(obj.parent is Interactible and obj.parent.usedBy != null):
			return obj.parent.usedBy
	if(obj):
		var bestDistance:float = INF
		var bestAgent:Agent = null
		for agent in AgentList:
			if(agent.objectInHand == obj):
				return agent
			var distance:float = agent.storePoint.global_position.distance_to(obj.global_position)
			if(agent.objectInHand == null and agent.task == null and distance < bestDistance):
				bestDistance = distance
				bestAgent = agent;
		return bestAgent
	return null
	
func find_closest_interactible(agent:Node3D, object:Node3D, s:String) -> Interactible:
	var bestDistance:float = INF
	var bestObj:Interactible = null
	for obj in get_tree().get_nodes_in_group(s):
		var distance:float = obj.global_position.distance_to(agent.global_position)
		if(obj.storedObject == object):
			return obj
		elif(not obj.occupied and not obj.storedObject and distance < bestDistance):
			bestDistance = distance
			bestObj = obj;
	return bestObj


func find_free_interactible(s:String) -> Interactible:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied and not obj.storedObject):
			return obj
	return null


func find_free_plateHolder() -> Interactible:
	for obj in get_tree().get_nodes_in_group("GeneratorEmptyPlate"):
		if(obj.plateList.size() > 0):
			return obj
	return null

func find_closest_plateHolder(agent:Node3D) -> Interactible:
	var bestDistance:float = INF
	var bestInt:Interactible = null
	for obj in get_tree().get_nodes_in_group("GeneratorEmptyPlate"):
		var distance:float = obj.global_position.distance_to(agent.global_position)
		if(not obj.occupied and not obj.storedObject and distance < bestDistance and obj.plateList.size() < 4):
			bestDistance = distance
			bestInt = obj;
			
	return bestInt

func dropToNearestCounter(agent:Agent):
	var obj = agent.objectInHand
	if(obj is Plate and not obj.needed): 
		var nearestPlateholder = find_closest_plateHolder(agent)
		if(nearestPlateholder):
			if(agent.task):
				agent.task.abandon()
			setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, obj), nearestPlateholder, Enum.Order.STORE)
			return
			
	if(obj is MovableStorage and not obj is Plate): #permet de reposer les pan ou pot sur les stove
		var nearestCooker = find_closest_interactible(agent, obj, "IntCOOK")
		if(nearestCooker):
			if(agent.task):
				agent.task.abandon()
			setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, obj), nearestCooker, Enum.Order.STORE)
			return
	
	var nearestCounter = find_closest_interactible(agent, obj, "IntSTORE")
	if(nearestCounter):
		if(agent.task):
			agent.task.abandon()
		setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, obj), nearestCounter, Enum.Order.STORE)
	else:
		agent.dropObject()


func setAgentTarget(agent:Cook, task:Task, destination:Node3D, order:Enum.Order = Enum.Order.NONE):
	if agent is Player:
		return true
	if(agent and task and destination):
		task.start(destination, agent)
		agent.order = order
		agent.executeTask()
		#print(agent.name + " " + Enum.TaskType.keys()[task.type])
		return true
	return false


func createTask(taskType:Enum.TaskType, needed:Array) -> bool:
	match taskType:
		Enum.TaskType.PICKUP:
			var obj = needed[0]
			var agent = findAgentClosestToObj(obj)
			var task = Task.new(self, taskType, obj)
			return setAgentTarget(agent, task, obj, Enum.Order.PICKUP)
		Enum.TaskType.GENERATE_TOMATO:
			var dest = find_free_interactible("GeneratorTom")
			var agent = findAgentClosestToObj(dest)
			var task = Task.new(self, taskType, null, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.UNSTORE)
		Enum.TaskType.GENERATE_BURGER:
			var dest = find_free_interactible("GeneratorBur")
			var agent = findAgentClosestToObj(dest)
			var task = Task.new(self, taskType, null, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.UNSTORE)
		Enum.TaskType.GENERATE_STEAK:
			var dest = find_free_interactible("GeneratorSte")
			var agent = findAgentClosestToObj(dest)
			var task = Task.new(self, taskType, null, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.UNSTORE)
		Enum.TaskType.GENERATE_SALAD:
			var dest = find_free_interactible("GeneratorSal")
			var agent = findAgentClosestToObj(dest)
			var task = Task.new(self, taskType, null, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.UNSTORE)
		Enum.TaskType.GENERATE_PLATE:
			var dest = find_free_plateHolder()
			var agent = findAgentClosestToObj(dest)
			if(agent):
				var task = Task.new(self, taskType, null, dest)
				return setAgentTarget(agent, task, dest, Enum.Order.UNSTORE)
		Enum.TaskType.CUT:
			var obj = needed[0]
			var agent = findAgentClosestToObj(obj)
			if(agent):
				var dest = find_closest_interactible(agent, obj, "IntCUT")
				var task = Task.new(self, taskType, obj, dest)
				return setAgentTarget(agent, task, dest, Enum.Order.USE)
		Enum.TaskType.COOK:
			var obj = needed[0]
			if not (obj.parent and obj.parent is IntStove):
				var agent = findAgentClosestToObj(obj)
				if(agent):
					var dest = find_closest_interactible(agent, obj, "IntCOOK")
					var task = Task.new(self, taskType, obj, dest)
					return setAgentTarget(agent, task, dest, Enum.Order.USE)
		Enum.TaskType.MIX:
			var obj = needed[0]
			var dest = needed[1]
			if(needed[0] is MovableStorage):
				obj = needed[1]
				dest = needed[0]
			var agent = findAgentClosestToObj(obj)
			var task = Task.new(self, taskType, obj, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.MIX)
		Enum.TaskType.EMPTY:
			var dest = find_free_interactible("IntEMPTY")
			var obj = needed[0]
			var agent = findAgentClosestToObj(obj)
			var task = Task.new(self, taskType, obj, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.STORE)
	return false

func presentOnMap(obj:Movable, recipe:Enum.RecipeNames):
	return obj.recipe == recipe

func primaryIngredientsPresentOnMap(obj:Movable, recipe:Enum.RecipeNames):
	return Recipes.dict_contains_keys(Recipes.getRecipePrimaryIngredients(recipe), Recipes.getRecipePrimaryIngredients(obj.recipe))

func recipeExists(recipe:Enum.RecipeNames, noplate = false):
	for m in MovableList:
		if(m.recipe == recipe):
			if not (noplate and m is Plate):
				MovableList.erase(m)
				return m

func dict_value_sum(d: Dictionary) -> int:
	var total := 0
	for v in d.values():
		total += v
	return total


func insert_sorted_dict(arr: Array, elem: Movable) -> void:
	var target := dict_value_sum(Recipes.getRecipePrimaryIngredients(elem.recipe))
	var low := 0
	var high := arr.size()
	while low < high:
		var mid := (low + high) >> 1 
		var mid_sum := dict_value_sum(Recipes.getRecipePrimaryIngredients(arr[mid].recipe))
		if mid_sum < target:
			high = mid 
		else:
			low = mid + 1 
	arr.insert(low, elem)

func TestRecipeDoable(recipe:Enum.RecipeNames, foundIngredients:Array[Movable] = [], noplate = false): #return missing ingredients
	var needed = Recipes.getNeeded(recipe).duplicate()
	var neededIngredient:Array[Movable];
	var exists = recipeExists(recipe, noplate) #we test if the recipe is already present in the world, and return it if so
	if(exists) : 
		return exists

	#if(recipe in [8, 18, 19, 23]) : print(Enum.RecipeNames.keys()[recipe], " " , needed.keys().map(func(x):return Enum.RecipeNames.keys()[x]))
	if(Recipes.getTaskType(recipe) == Enum.TaskType.MIX):
		var foundPlate = false
		var arr:Array[Movable]
		for i in MovableList:
			if Recipes.dict_contains_keys(needed, Recipes.getRecipePrimaryIngredients(i.recipe)):
				insert_sorted_dict(arr, i)#we order them to check the biggest first (this avoid most conflicts)
		for i in arr:
			if Recipes.dict_contains_keys(needed, Recipes.getRecipePrimaryIngredients(i.recipe)) and not (foundPlate and i is Plate):
				needed = Recipes.subtract_dictionary(needed, Recipes.getRecipePrimaryIngredients(i.recipe))
				neededIngredient.append(i)
				if(i is Plate):
					needed = Recipes.subtract_dictionary(needed, {Enum.RecipeNames.EmptyPlate:1})
					foundPlate = true
				MovableList.erase(i)
	#if(recipe in [8, 18, 19, 23]) : print(Enum.RecipeNames.keys()[recipe], " " , needed.keys().map(func(x):return Enum.RecipeNames.keys()[x]))
		
	for i in needed.keys():#if not we try recursively to find if every ingredient needed is present
		for j in range(needed[i]):
			var ing = TestRecipeDoable(i, foundIngredients, Recipes.getTaskType(recipe))
			if(ing):
				foundIngredients.append(ing)

	for i in needed.keys():#then we try to assemble the recipe with all the foundIngredients not used by the children
		for j in range(needed[i]):
			var foundIndex = -1
			if(Recipes.getTaskType(recipe) == Enum.TaskType.MIX):
				foundIndex = foundIngredients.find_custom(primaryIngredientsPresentOnMap.bind(i))
				if foundIndex != -1:
					neededIngredient.append(foundIngredients[foundIndex])
					needed = Recipes.subtract_dictionary(needed, Recipes.getRecipePrimaryIngredients(i))
			else:
				foundIndex = foundIngredients.find_custom(presentOnMap.bind(i))
				if foundIndex != -1:
					neededIngredient.append(foundIngredients[foundIndex])
					needed = Recipes.subtract_dictionary(needed, {i:1})

	if Recipes.getTaskType(recipe) == Enum.TaskType.MIX and neededIngredient.size() > 1:
		var k = 0
		while k < neededIngredient.size()-1 and not neededIngredient[k] is MovableStorage:
			k += 1
		if neededIngredient[k] is MovableStorage:
			for i in range(0, neededIngredient.size(), 1):
				if(i != k and createTask(Enum.TaskType.MIX, [neededIngredient[i], neededIngredient[k]])):
					MovableList.erase(neededIngredient[i])
					foundIngredients.erase(neededIngredient[i])
	
	elif(needed == {}):
		if(createTask(Recipes.getTaskType(recipe), neededIngredient)):
			for m2 in neededIngredient:
				MovableList.erase(m2)
				foundIngredients.erase(m2)
		return null
	return null

func initiateProcess():
	MovableList = []
	RecipeNeededList = []
	DirtyPlateList = []
	for plate in get_tree().get_nodes_in_group("dirtyPlate"):
		DirtyPlateList.append(plate)
	for movable in get_tree().get_nodes_in_group("movable"):
		MovableList.append(movable)
		if movable is Plate:
			movable.setNeeded(true)
	for a in AgentList:
		a.task = null
	for i in get_tree().get_nodes_in_group("interactible"):
		if not i.storedObject:
			i.occupied = false
	#print(MovableList.map(func(x): return Enum.RecipeNames.keys()[x.recipe]))

func _process(_delta):
	if(printNewFrame) : print("\nnew frame")
	initiateProcess()
	for p in DirtyPlateList:
		var agent = findAgentClosestToObj(p)
		if(agent):
			var dest = find_closest_interactible(agent, p, "IntCLEAN")
			var task = Task.new(self, Enum.TaskType.CLEAN, p, dest)
			setAgentTarget(agent, task, dest, Enum.Order.USE)

	for p in servePoints:
		if(p.recipeWanted != Enum.RecipeNames.Empty):
			var recipeFinished = recipeExists(p.recipeWanted)
			if(recipeFinished):
				var agent = findAgentClosestToObj(recipeFinished)
				var task = Task.new(self, Enum.TaskType.EMPTY, recipeFinished, p)
				setAgentTarget(agent, task, p, Enum.Order.STORE)
			else:
				TestRecipeDoable(p.recipeWanted)

	for p in MovableList:
		if p is Plate and p.recipe == Enum.RecipeNames.EmptyPlate:
			p.setNeeded(false)
	
	for a in AgentList:
		if a.objectInHand:
			if not a.task:
				dropToNearestCounter(a)
			elif a.task and a.objectInHand != a.task.object:
				dropToNearestCounter(a)

	for i in get_tree().get_nodes_in_group("interactible"):
		i.usedBy = null

func _enter_tree():
	add_to_group("Hierarchy")

#func _ready():
	#Engine.time_scale = 1
	#print(Recipes.subtract_dictionary(Recipes.getRecipePrimaryIngredients(Enum.RecipeNames.PotCutTomCutTomCutTom), Recipes.getRecipePrimaryIngredients(Enum.RecipeNames.CutTom)))
