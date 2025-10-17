extends Node3D
class_name Hierarchy

var AgentList:Array[Agent]
var MovableList:Array[Movable]
var RecipeNeededList:Array[Enum.RecipeNames]
var TaskList:Array[Task]
var availableAgent:int
var recipeToPrepare:Array[Enum.RecipeNames] = [Enum.RecipeNames.TomatoSoup]

func findAgentClosestToTask(task:Task) -> Agent:
	var obj = task.object
	if(obj and availableAgent > 0):
		if(obj is Movable and obj.parent is Agent and obj.parent.task == null):
			return obj.parent
		return findAgentClosestToObj(task.object)
	return null
	
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

func find_free_movable(s:String) -> Movable:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied):
			return obj
	return null

func find_free_interactible(s:String) -> Interactible:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied and not obj.storedObject):
			return obj
	return null

func find_free_oject_on_table(movable:String, taskType:Enum.TaskType) -> Node3D:
	for obj in get_tree().get_nodes_in_group(movable):
		if(obj.parent and obj.parent.taskType == taskType and not obj.occupied):
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



func createSoup():
	var emptyPot = find_free_movable("PotEMPTY")
	if(emptyPot):
		var soupServe:Task = Task.new(self, Enum.TaskType.EMPTY, emptyPot)
		TaskList.append(soupServe)
		var soupCook:Task = Task.new(self, Enum.TaskType.COOK, emptyPot)
		soupServe.addPrevious(soupCook)
		TaskList.append(soupCook)
		for i in range(3):
			var tomPot:Task = Task.new(self, Enum.TaskType.MIX, null, emptyPot)
			TaskList.append(tomPot)
			soupCook.addPrevious(tomPot)
			var tomCut:Task = Task.new(self, Enum.TaskType.CUT)
			TaskList.append(tomCut)
			tomPot.addPrevious(tomCut)
			var ing = find_free_movable("Tom")
			if(ing):
				tomCut.object = ing
			else:
				var tomGen:Task = Task.new(self, Enum.TaskType.GENERATE_TOMATO)
				TaskList.append(tomGen)
				tomCut.addPrevious(tomGen)

func createBurger():
	var emptyPan = find_free_movable("PanEMPTY")
	if(emptyPan):
		var burgServe:Task = Task.new(self, Enum.TaskType.EMPTY)
		TaskList.append(burgServe)
		
		var salMix:Task = Task.new(self, Enum.TaskType.MIX)
		TaskList.append(salMix)
		burgServe.addPrevious(salMix)
		var steEmpty:Task = Task.new(self, Enum.TaskType.EMPTY)
		TaskList.append(steEmpty)
		burgServe.addPrevious(steEmpty)
		
		var steCook:Task = Task.new(self, Enum.TaskType.COOK, emptyPan)
		TaskList.append(steCook)
		steEmpty.addPrevious(steCook)
		
		var stePan:Task = Task.new(self, Enum.TaskType.MIX, null, emptyPan)
		TaskList.append(stePan)
		steCook.addPrevious(stePan)
		
		var salCut:Task = Task.new(self, Enum.TaskType.CUT)
		TaskList.append(salCut)
		salMix.addPrevious(salCut)
		var steCut:Task = Task.new(self, Enum.TaskType.CUT)
		TaskList.append(steCut)
		stePan.addPrevious(steCut)
		
		var burGen:Task = Task.new(self, Enum.TaskType.GENERATE_BURGER)
		TaskList.append(burGen)
		burGen.giveDestinationTo = [salMix, steEmpty]
		
		var steGen = Task.new(self, Enum.TaskType.GENERATE_STEAK)
		TaskList.append(steGen)
		steCut.addPrevious(steGen)
		var salGen = Task.new(self, Enum.TaskType.GENERATE_SALAD)
		TaskList.append(salGen)
		salCut.addPrevious(salGen)

func pickup(task:Task):
	var agent = findAgentClosestToTask(task)
	if(agent):
		setAgentTarget(agent, task, task.object, Enum.Order.PICKUP)
	
func generate(task:Task, ingName:Enum.RecipeNames):
	var generator = find_free_interactible("Generator"+Enum.RecipeNames.keys()[ingName])
	var agent
	if(generator):
		agent = findAgentClosestToObj(generator)
	if(agent):
		setAgentTarget(agent, task, generator, Enum.Order.UNSTORE)

func cut(task:Task):
	var cutter = find_free_interactible("IntCUT")
	var agent = findAgentClosestToTask(task)
	if(agent and cutter):
		setAgentTarget(agent, task, cutter, Enum.Order.USE)

		
func mix(task:Task):
	var agent = findAgentClosestToTask(task)
	if(agent):
		setAgentTarget(agent, task, task.destination, Enum.Order.MIX)

func cook(task:Task):
	var stove
	if(task.object.parent and task.object.parent is IntStove):
		stove = task.object.parent
	else:
		stove = find_free_interactible("IntCOOK")
	var agent = findAgentClosestToTask(task)
	if(agent and stove):
		setAgentTarget(agent, task, stove, Enum.Order.STORE)

func empty(task:Task):
	if(task.object is Ingredient):
		var servePoint = find_free_interactible("IntEMPTY")
		var agent = findAgentClosestToTask(task)
		if(agent and servePoint):
			setAgentTarget(agent, task, servePoint, Enum.Order.STORE)
	elif(task.object and task.object.canEmpty()):
		if(task.destination == null or task.destination is IntServe):
			var servePoint = find_free_interactible("IntEMPTY")
			var agent = findAgentClosestToTask(task)
			if(agent and servePoint):
				setAgentTarget(agent, task, servePoint, Enum.Order.STORE)
		else:
			var agent = findAgentClosestToTask(task)
			if(agent):
				setAgentTarget(agent, task, task.destination, Enum.Order.MIX)


func assignTasks(task:Task):
	#print(str(task) + " " + str(task.previousTasks.size())+ " " + str(task.occupied) + " " +str(task.assignedAgent))
	if(task.previousTasks.size() == 0 and task.available()):
		match task.type:
			Enum.TaskType.PICKUP:
				pickup(task)
			Enum.TaskType.GENERATE_TOMATO:
				generate(task, Enum.RecipeNames.Tom)
			Enum.TaskType.GENERATE_BURGER:
				generate(task, Enum.RecipeNames.Bur)
			Enum.TaskType.GENERATE_STEAK:
				generate(task, Enum.RecipeNames.Ste)
			Enum.TaskType.GENERATE_SALAD:
				generate(task, Enum.RecipeNames.Sal)
			Enum.TaskType.CUT:
				cut(task)
			Enum.TaskType.COOK:
				cook(task)
			Enum.TaskType.MIX:
				mix(task)
			Enum.TaskType.EMPTY:
				empty(task)

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

func validOperation(obj:Movable, recipe:Enum.RecipeNames, prevIsMix:bool):
	if obj.recipe == recipe:
		return true
	if Recipes.getTaskType(recipe) == Enum.TaskType.MIX and prevIsMix:
		var task1 = Recipes.getTaskType(Recipes.getNeeded(recipe)[0])
		var task2 = Recipes.getTaskType(Recipes.getNeeded(recipe)[1])
		if(task1 == Enum.TaskType.MIX):
			if validOperation(obj, Recipes.getNeeded(recipe)[0], true):
				print(Enum.RecipeNames.keys()[recipe] + " " +Enum.RecipeNames.keys()[obj.recipe])
				return true
		if(task2 == Enum.TaskType.MIX):
			if validOperation(obj, Recipes.getNeeded(recipe)[1], true):
				print(Enum.RecipeNames.keys()[recipe] + " " +Enum.RecipeNames.keys()[obj.recipe])
				return true
	return false

func TestRecipeDoable(recipe:Enum.RecipeNames, _calledByMixed:bool = false, foundIngredients:Array[Movable] = []): #return missing ingredients
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
		var foundIndex = foundIngredients.find_custom(validOperation.bind(i, Recipes.getTaskType(recipe) == Enum.TaskType.MIX))
		if foundIndex != -1:
			neededIngredient.append(foundIngredients[foundIndex])
			ingleft -= 1


	if(ingleft == 0):
		if(createTask(Recipes.getTaskType(recipe), neededIngredient)):
			for m2 in neededIngredient:
				MovableList.erase(m2)
				foundIngredients.erase(m2)
			if _calledByMixed and Recipes.getTaskType(recipe) == Enum.TaskType.MIX:
				return neededIngredient[1]
		return null
	return null

func initiateProcess():
	print("\n\n\nnewframe")
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
	for r in recipeToPrepare:
		var res = TestRecipeDoable(r)
		if res and res.recipe == r:
			createTask(Enum.TaskType.EMPTY, [res])


	for a in AgentList:
		if a.task == null and a.objectInHand:
			dropToNearestCounter(a)
		elif a.task and a.objectInHand and a.objectInHand != a.task.object:
			dropToNearestCounter(a)


func _enter_tree():
	add_to_group("Hierarchy")

	
