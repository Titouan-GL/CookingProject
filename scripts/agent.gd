extends Cook
class_name Agent
@export var nav_agent: NavAgent
var order: Enum.Order
var hierarchy:Hierarchy
var task:Task
var isCutting:bool = false #used for animation
var isCleaning:bool = false #used for animation
var grabTime = 0
var maxGrabTime = 0.1

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
							if target.use(delta):
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
	target_angle = lerpf(target_angle, atan2(-addedVelocity.x, -addedVelocity.z), addedVelocity.length()/50)
	var new_angle = lerp_angle(rotation.y, target_angle, delta *15)
	rotation.y = new_angle
	var planarVelocity = (direction  + addedVelocity).normalized() * SPEED
	velocity = lerp(velocity, Vector3(0, -gravity, 0) + planarVelocity, ACCELERATION*delta)
	
	super._physics_process(delta)
	move_and_slide()

func _ready():
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	hierarchy.AgentList.append(self)
	
func _enter_tree():
	add_to_group("freeAgent")
	super._enter_tree()

func _init() -> void:
	SPEED = 5
	ACCELERATION = 25
	bumpStrength = 7
	gravity = 20
	friction = 40

func _process(_delta):
	if grabTime > 0:
		grabTime -= _delta
	#executeTask()
