extends Node3D
class_name Hierarchy

var AgentList:Array[Agent]
var MovableList:Array[Movable]
var RecipeNeededList:Array[Enum.RecipeNames]
var availableAgent:int
var recipeToPrepare:Array[Enum.RecipeNames] = []

func findAgentClosestToObj(obj:Node3D) -> Agent:
	var bestDistance:float = INF
	var bestAgent:Agent = null
	for agent in AgentList:
		var distance:float = agent.storePoint.global_position.distance_to(obj.global_position)
		if(agent.task == null and distance < bestDistance):
			bestDistance = distance
			bestAgent = agent;
	return bestAgent
	
func find_closest_interactible(n:Node3D, s:String) -> Interactible:
	var bestDistance:float = INF
	var bestObj:Interactible = null
	for obj in get_tree().get_nodes_in_group(s):
		var distance:float = obj.global_position.distance_to(n.global_position)
		if(obj.storedObject == n):
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
		var nearestCooker = find_closest_interactible(agent, "IntCOOK")
		if(nearestCooker):
			if(agent.task):
				agent.task.abandon()
			setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, agent.objectInHand), nearestCooker, Enum.Order.STORE)
			return
	
	var nearestCounter = find_closest_interactible(agent, "IntSTORE")
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
			var dest = find_closest_interactible(obj, "IntCUT")
			var agent = findAgentClosestToObj(obj)
			var task = Task.new(self, taskType, obj, dest)
			return setAgentTarget(agent, task, dest, Enum.Order.USE)
		Enum.TaskType.COOK:
			var obj = needed[0]
			if not (obj.parent and obj.parent is IntStove):
				var dest = find_closest_interactible(obj, "IntCOOK")
				var agent = findAgentClosestToObj(obj)
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
		var task1 = Recipes.getTaskType(Recipes.getNeeded(recipe)[0]);
		var task2 = Recipes.getTaskType(Recipes.getNeeded(recipe)[1]);
		if(task1 == Enum.TaskType.MIX || task1 == Enum.TaskType.INITAL_MIXER):
			if validOperation(obj, Recipes.getNeeded(recipe)[0]):
				return true
		if(task2 == Enum.TaskType.MIX || task2 == Enum.TaskType.INITAL_MIXER):
			if validOperation(obj, Recipes.getNeeded(recipe)[1]):
				return true
	return false

func TestRecipeDoable(recipe:Enum.RecipeNames, calledByMixed:bool = false, foundIngredients:Array[Movable] = []): #return missing ingredients
	var ingleft = Recipes.getNeeded(recipe).size()
	var neededIngredient:Array[Movable];

	for m in MovableList:
		if(m.recipe == recipe):
			MovableList.erase(m)
			return m
	for i in Recipes.getNeeded(recipe):
		if i:
			var ing = TestRecipeDoable(i, Recipes.getTaskType(recipe) == Enum.TaskType.MIX, foundIngredients)
			if(ing):
				foundIngredients.append(ing)

	for i in Recipes.getNeeded(recipe):
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
	initiateProcess()
	if recipeToPrepare.size() < 2:
		recipeToPrepare.append([Enum.RecipeNames.TomatoSoup].pick_random())
	for r in recipeToPrepare:
		var res = TestRecipeDoable(r)
		if res and res.recipe == r:
			createTask(Enum.TaskType.EMPTY, [res])
			recipeToPrepare.erase(res.recipe)


	for a in AgentList:
		if a.task == null and a.objectInHand:
			dropToNearestCounter(a)
		elif a.task and a.objectInHand and a.objectInHand != a.task.object:
			dropToNearestCounter(a)


func _enter_tree():
	add_to_group("Hierarchy")

	
