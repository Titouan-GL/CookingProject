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

func validOperation(obj:Movable, recipe:Enum.RecipeNames):
	if obj.recipe == recipe:
		return true
	if Recipes.getTaskType(recipe) == Enum.TaskType.MIX:
		var needed = Recipes.getNeeded(recipe)
		for i in range(2):
			var task = Recipes.getTaskType(needed[i]);
			if(task == Enum.TaskType.MIX || task == Enum.TaskType.INITAL_MIXER):
				if validOperation(obj, needed[i]):
					return true
	return false

func recipeExists(recipe:Enum.RecipeNames):
	for m in MovableList:
		if(m.recipe == recipe):
			MovableList.erase(m)
			return m

func TestRecipeDoable(recipe:Enum.RecipeNames, calledByMixed:bool = false, foundIngredients:Array[Movable] = []): #return missing ingredients
	var needed = Recipes.getNeeded(recipe)
	var ingleft = needed.size()
	var neededIngredient:Array[Movable];

	var exists = recipeExists(recipe)
	if(exists) : 
		return exists
	for i in needed:
		if i:
			var ing = TestRecipeDoable(i, Recipes.getTaskType(recipe) == Enum.TaskType.MIX, foundIngredients)
			if(ing):
				foundIngredients.append(ing)

	for i in needed:
		var foundIndex = foundIngredients.find_custom(validOperation.bind(i))
		if foundIndex != -1:
			neededIngredient.append(foundIngredients[foundIndex])
			ingleft -= 1

	if(ingleft == 0):
		if(createTask(Recipes.getTaskType(recipe), neededIngredient)):
			for m2 in neededIngredient:
				MovableList.erase(m2)
				foundIngredients.erase(m2)
			if calledByMixed and Recipes.getTaskType(recipe) == Enum.TaskType.MIX:
				return neededIngredient[1]
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

func _ready():
	print(Enum.RecipeNames.BurSteSalTom)
	Recipes.packed_bytes_to_binary(Recipes.getRecipeBinary(Enum.RecipeNames.BurSteSalTom))
