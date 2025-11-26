extends Cook
class_name Agent
@export var nav_agent: NavAgent
@export var mesh: Node3D
var order: Enum.Order
var hierarchy:Hierarchy
var task:Task
var isCutting:bool = false #used for animation
var isCleaning:bool = false #used for animation
var grabTime = 0
var maxGrabTime = 0.1
var gameManager:GameManager
var prohibitedTasks:Array[Enum.TaskType]
static var speedRange = Vector3(3, 5, 7)
static var dishesRange = Vector3(0.5, 1.5, 3)
static var cuttingRange = Vector3(0.5, 1.5, 3)


func act():
	grabTime = maxGrabTime

func executeTask():
	if(task and grabTime <= 0):
		#if(objectInHand):
			#print(name, " " , Enum.TaskType.keys()[task.type], " ", Enum.RecipeNames.keys()[objectInHand.recipe])
		#else:
			#print(name, " " , Enum.TaskType.keys()[task.type], " nothing in hands")
		var delta = get_process_delta_time()
		var target = task.destination
		if(target):
			#if target is IntServe : print(objectInHand, " " , task.object)
			if((target is Interactible and target.storedObject == task.object and not target is IntGenerator) or objectInHand == task.object):
				nav_agent.set_target_position(target.global_position)
				#if target is IntServe : print("ok c'est valide")
				if(nav_agent.is_navigation_finished()):
					match order:
						Enum.Order.USE:
							if(objectInHand):
								target.store(objectInHand) 
							var finished = false
							if target is IntSink:
								finished = target.use(delta * dishesSpeed)
							elif target is IntCutter:
								finished = target.use(delta * cuttingSpeed)
							else:
								finished = target.use(delta)
							if finished:
								if(task.type == Enum.TaskType.CLEAN):
									act()
									var obj = target.unstore()
									pickUp(obj)
								task.complete()
									
						Enum.Order.STORE:
							act()
							target.store(objectInHand) 
							task.complete()
						Enum.Order.UNSTORE:
							act()
							var obj = target.unstore()
							pickUp(obj)
							task.complete()
						Enum.Order.PICKUP:
							act()
							pickUp(task.object)
							task.complete()
						Enum.Order.MIX:
							act()
							if(task.object is Ingredient): 
								task.destination.mix(task.object)
							elif(task.destination is Ingredient):
								task.object.mix(task.destination)
							else: #both are movablestorage
								if(task.object.emptyName in Recipes.getRecipePrimaryIngredients(Recipes.recipesMix(task.destination.recipe, task.object.recipe))):
									task.object.mixRecipe(task.destination.empty())
								else:
									if(task.object.recipe == task.object.emptyName):
										task.object.mixRecipe(task.destination.empty())
									else:
										task.destination.mixRecipe(task.object.empty())
							task.complete()
			elif task.object:
				nav_agent.set_target_position(task.object.global_position)
				if(nav_agent.is_navigation_finished()):
					act()
					pickUp(task.object)


func _physics_process(delta):
	var direction:Vector3 = Vector3.ZERO
	var target_angle:float = rotation.y
	var next_path_position = nav_agent.get_next_path_position()
	if task and not nav_agent.is_navigation_finished() and task.destination:
		direction = Vector3(next_path_position.x - global_position.x, 0, next_path_position.z-global_position.z).normalized()
		target_angle = atan2(direction.x, direction.z)
	elif task and task.object:
		var objDirection = (task.object.global_position - global_position).normalized()
		target_angle = atan2(objDirection.x, objDirection.z)
	target_angle = lerp_angle(target_angle, atan2(-addedVelocity.x, -addedVelocity.z), addedVelocity.length()/50)
	var new_angle = lerp_angle(rotation.y, target_angle, delta *15)
	rotation.y = new_angle
	var planarVelocity = (direction  + addedVelocity).normalized() * speed
	velocity = lerp(velocity, Vector3(0, -gravity, 0) + planarVelocity, ACCELERATION*delta)

	super._physics_process(delta)
	move_and_slide()

func prohibitTask(type:Enum.TaskType):
	if not type in prohibitedTasks:
		prohibitedTasks.append(type)
		
func allowTask(type:Enum.TaskType):
	if type in prohibitedTasks:
		prohibitedTasks.erase(type)

func _ready():
	hierarchy = get_tree().get_first_node_in_group("Hierarchy")
	gameManager = get_tree().get_first_node_in_group("GameManager")
	hierarchy.AgentList.append(self)
	CreateAppearance()
	UpdateAppearance()
	gameManager.addAgentIcon(self, mesh, characterName)

func _enter_tree():
	add_to_group("freeAgent")
	super._enter_tree()


func rand_gamma(k: float) -> float:
	if k < 1.0:
		while true:
			var u = randf()
			var v = randf()
			var x = pow(u, 1.0 / k)
			var y = pow(v, 1.0 / (1.0 - k))
			if x + y <= 1.0:
				return -log(randf()) * x / (x + y)
	else:
		var d = k - 1.0/3.0
		var c = 1.0 / sqrt(9.0 * d)
		while true:
			var x = randf() 
			var v = 1.0 + c * x
			if v > 0.0:
				v = v * v * v
				var u = randf()
				if u < 1.0 - 0.0331 * x * x * x * x:
					return d * v
				if log(u) < 0.5 * x * x + d * (1.0 - v + log(v)):
					return d * v
	return 0


func rand_beta(alpha: float, beta: float) -> float:
	var x = rand_gamma(alpha)
	var y = rand_gamma(beta)
	return x / (x + y)

func rand_with_mean(mu: float, k: float = 2.0) -> float:
	var alpha = mu * k
	var beta = (1.0 - mu) * k
	return rand_beta(alpha, beta)

func randMaxAvgMin(minVal:float, avg:float, maxVal:float):
	var quantile = roundf(10*(rand_with_mean((avg-minVal)/(maxVal-minVal))))/10
	return minVal + quantile*(maxVal-minVal)


func initRandomStats():
	speed = randMaxAvgMin(speedRange.x, speedRange.y, speedRange.z)
	cuttingSpeed = randMaxAvgMin(cuttingRange.x, cuttingRange.y, cuttingRange.z)
	dishesSpeed = randMaxAvgMin(dishesRange.x, dishesRange.y, dishesRange.z)

func _init() -> void:
	ACCELERATION = 25
	bumpStrength = 7
	gravity = 20
	friction = 40
	initRandomStats()

func _process(_delta):
	if grabTime > 0:
		grabTime -= _delta
	#executeTask()
