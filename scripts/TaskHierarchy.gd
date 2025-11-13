extends Node3D
class_name Hierarchy

var AgentList:Array[Agent]
var MovableList:Array[Movable]
var RecipeNeededList:Array[Enum.RecipeNames]
var servePoints:Array = []
var printNewFrame = false

func findAgentClosestToObj(obj:Node3D) -> Agent:
	var bestDistance:float = INF
	var bestAgent:Agent = null
	for agent in AgentList:
		var distance:float = agent.storePoint.global_position.distance_to(obj.global_position)
		if(agent.task == null and distance < bestDistance):
			bestDistance = distance
			bestAgent = agent;
	return bestAgent
	
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

func dropToNearestCounter(agent:Agent):
	if(agent.objectInHand is MovableCooker): #permet de reposer les pan ou pot sur les stove
		var nearestCooker = find_closest_interactible(agent, agent.objectInHand, "IntCOOK")
		if(nearestCooker):
			if(agent.task):
				agent.task.abandon()
			setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, agent.objectInHand), nearestCooker, Enum.Order.STORE)
			return
	
	var nearestCounter = find_closest_interactible(agent, agent.objectInHand, "IntSTORE")
	if(nearestCounter):
		if(agent.task):
			agent.task.abandon()
		setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, agent.objectInHand), nearestCounter, Enum.Order.STORE)
	else:
		agent.dropObject()


func setAgentTarget(agent:Agent, task:Task, destination:Node3D, order:Enum.Order = Enum.Order.NONE):
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
			if(needed[0] is MovableCooker):
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

func recipeExists(recipe:Enum.RecipeNames):
	for m in MovableList:
		if(m.recipe == recipe):
			MovableList.erase(m)
			return m

func TestRecipeDoable(recipe:Enum.RecipeNames, foundIngredients:Array[Movable] = []): #return missing ingredients
	var needed = Recipes.getNeeded(recipe).duplicate()
	var neededIngredient:Array[Movable];
	var exists = recipeExists(recipe) #we test if the recipe is already present in the world, and return it if so
	if(exists) : 
		return exists

	#print(recipe, " " , needed)
	if(Recipes.getTaskType(recipe) == Enum.TaskType.MIX):
		var i = 0
		while i < MovableList.size():
			if Recipes.dict_contains_keys(needed, Recipes.getRecipePrimaryIngredients(MovableList[i].recipe)):
				needed = Recipes.subtract_dictionary(needed, Recipes.getRecipePrimaryIngredients(MovableList[i].recipe))
				neededIngredient.append(MovableList[i])
				MovableList.erase(MovableList[i])
			else:
				i += 1

	#print(recipe, " " , needed)
	for i in needed.keys():#if not we try recursively to find if every ingredient needed is present
		for j in needed[i]:
			var ing = TestRecipeDoable(i, foundIngredients)
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
		for i in range(1, neededIngredient.size(), 1):
			if(createTask(Enum.TaskType.MIX, [neededIngredient[i], neededIngredient[0]])):
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
	for movable in get_tree().get_nodes_in_group("movable"):
		MovableList.append(movable)
	for a in AgentList:
		a.task = null
	for i in get_tree().get_nodes_in_group("interactible"):
		if not i.storedObject:
			i.occupied = false

func _process(_delta):
	if(printNewFrame) : print("\n\nnewFrame")
	initiateProcess()
	for p in servePoints:
		if(p.recipeWanted != Enum.RecipeNames.Empty):
			var recipeFinished = recipeExists(p.recipeWanted)
			if(recipeFinished):
				var agent = findAgentClosestToObj(recipeFinished)
				var task = Task.new(self, Enum.TaskType.EMPTY, recipeFinished, p)
				setAgentTarget(agent, task, p, Enum.Order.STORE)
			else:
				TestRecipeDoable(p.recipeWanted)

	for a in AgentList:
		if a.objectInHand:
			if not a.task:
				dropToNearestCounter(a)
			elif a.task and a.objectInHand != a.task.object:
				dropToNearestCounter(a)


func _enter_tree():
	add_to_group("Hierarchy")

#func _ready():
	#print(Recipes.subtract_dictionary(Recipes.getRecipePrimaryIngredients(Enum.RecipeNames.PotCutTomCutTomCutTom), Recipes.getRecipePrimaryIngredients(Enum.RecipeNames.CutTom)))
