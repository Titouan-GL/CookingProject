extends Object

class_name Task

var type:Enum.TaskType
var destination:Node3D
var object:Node3D
var occupied:bool
var previousTasks:Array[Task]
var nextTask:Task
var hierarchy:Hierarchy
var assignedAgent:Agent
var giveDestinationTo:Array

func _init(h:Hierarchy, t:Enum.TaskType, newObject:Node3D = null, newDestination:Node3D = null):
	hierarchy = h
	type = t
	object = newObject
	destination = newDestination
	occupied = false
	if object:
		object.assignedToTask(self)

func start(d:Node3D, agent:Agent):
	#if(type == Enum.TaskType.GENERATE_ONION):print(str(self) + " ok")
	assignedAgent = agent
	assignedAgent.remove_from_group("freeAgent")
	assignedAgent.task = self
	destination = d
	occupied = true
	if destination.canBeOccupied:
		destination.occupied = true
		#print("task : "+ str(Enum.TaskType.keys()[type]) + " " + str(self) + " started by " + agent.name + " to " + destination.name + " with " + object.name)
	#else:
		#print("task : "+ str(Enum.TaskType.keys()[type])  + " " + str(self) +  " started by " + agent.name + " to " + destination.name)

func abandon():
	#if(type == Enum.TaskType.GENERATE_ONION):print(str(self) + " ok2")
	#print("task : "+ str(Enum.TaskType.keys()[type])  + " " + str(self) +  " abandonned by " + assignedAgent.name + " to " + destination.name)
	occupied = false
	if(destination is Interactible):
		destination.occupied = false
	assignedAgent.task = null
	assignedAgent.add_to_group("freeAgent")
	assignedAgent = null
	

func previousTaskComplete(t:Task, n:Node3D):
	if(n):
		object = n
		object.assignedToTask(self)
	previousTasks.erase(t)

func complete(n:Node3D):
	#print("task : "+ str(Enum.TaskType.keys()[type])  + " " + str(self) +  " completed by " + assignedAgent.name + " to " + destination.name)
	assignedAgent.add_to_group("freeAgent")
	assignedAgent.task = null 
	assignedAgent.order = Enum.Order.NONE
	
	for t in giveDestinationTo:
		t.destination = n
	
	if(nextTask):
		n.occupied = true
		nextTask.previousTaskComplete(self, n)
		
	#if(destination): print("task complete : " + Enum.TaskType.keys()[type] + " to " + destination.name + " by " + agent.name)
	#else: print("task complete : " + Enum.TaskType.keys()[type] + " by " + agent.name)

func addPrevious(t:Task):
	previousTasks.append(t)
	t.nextTask = self

func objectInHandsOf() -> Agent:
	if(object and object.parent is Agent):
		return object.parent
	return null

func available()-> bool:
	return not occupied
