extends CharacterBody3D
class_name Agent
@export var nav_agent: NavAgent
@export var storePoint: Node3D  
const SPEED = 5
var objectInHand:Movable
var order: Enum.Order
var hierarchy:Hierarchy
var task:Task
var addedVelocity:Vector3 = Vector3.ZERO
var friction:float = 40
var bumpStrength:float = 7
var isCutting:bool = false #used for animation
var grabTime = 0
var maxGrabTime = 0.1

func pickUp(obj:Movable):
	if(objectInHand):
		objectInHand.dropped()
	obj.pickUp(self)
	objectInHand = obj

func act():
	grabTime = maxGrabTime

func executeTask():
	if(task and grabTime <= 0):
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
								task.complete(target.storedObject)
						Enum.Order.STORE:
							act()
							target.store(objectInHand) 
							task.complete(task.object)
						Enum.Order.UNSTORE:
							act()
							var obj = target.unstore()
							pickUp(obj)
							task.complete(obj)
						Enum.Order.PICKUP:
							act()
							pickUp(task.object)
							task.complete(objectInHand)
						Enum.Order.MIX:
							act()
							if(task.object is Ingredient):
								task.destination.mix(task.object)
								task.complete(task.destination)
							elif(task.object is MovableStorage):
								task.destination.mixRecipe(task.object.empty())
								task.complete(task.destination)
			elif task.object:
				nav_agent.set_target_position(task.object.global_position)
				if(nav_agent.is_navigation_finished()):
					act()
					pickUp(task.object)

func dropObject():
	objectInHand.dropped()
	objectInHand = null

func bumpedInto(dir:Vector3):
	var orthogonal = Vector3(dir.z , 0, -dir.x ).normalized()/2
	addedVelocity = (orthogonal + Vector3(dir.x, 0, dir.z))*bumpStrength

func _physics_process(delta):
	if(addedVelocity.length() > 0):
		var reduction = friction*delta
		addedVelocity -= addedVelocity.normalized() * reduction
		if(addedVelocity.length() < reduction ):
			addedVelocity = Vector3.ZERO
	
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
	velocity = Vector3(0, -1, 0) + (direction  + addedVelocity).normalized() * SPEED

	var collision = move_and_collide(velocity*delta, true)
	if(collision and (collision.get_collider() is Agent or collision.get_collider() is Client)):
		var dir:Vector3 = (collision.get_collider().global_position-global_position).normalized()
		collision.get_collider().bumpedInto(dir * 1.3)
		addedVelocity = dir*-bumpStrength
	move_and_slide()

func _ready():
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	hierarchy.AgentList.append(self)
	
func _enter_tree():
	add_to_group("freeAgent")
#
func _process(_delta):
	if grabTime > 0:
		grabTime -= _delta
	#executeTask()
