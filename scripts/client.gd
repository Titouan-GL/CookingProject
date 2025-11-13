extends CharacterBody3D
class_name Client
const SPEED = 3
var addedVelocity:Vector3 = Vector3.ZERO
var friction:float = 40
var bumpStrength:float = 2
var target:Node3D = null
var eatingState = 0 #1 if currently eating, 2 if already eaten
@export var navAgent:NavAgent
var sat:bool = false
@export var fork:Node3D
@export var knife:Node3D


func executeTask():
	if eatingState == 0 :
		if target == null:
			target = get_tree().get_nodes_in_group("freeServePoint").pick_random()
			navAgent.set_target_position(target.destinationPoint.global_position)
			target.reserved(self)
		elif navAgent.is_navigation_finished() and target.recipeWanted == Enum.RecipeNames.Empty :
			sat = true
			target.newRecipe()
			target.clientSat()
	if eatingState == 2:
		if target == null:
			sat = false
			target = get_tree().get_nodes_in_group("IntDOOR").pick_random()
			navAgent.set_target_position(target.global_position)
		elif navAgent.is_navigation_finished():
			queue_free()

func changeState(v):
	target = null
	eatingState = v

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
	var next_path_position = navAgent.get_next_path_position()
	if(not navAgent.is_navigation_finished()):
		direction = Vector3(next_path_position.x - global_position.x, 0, next_path_position.z-global_position.z).normalized()
		target_angle = atan2(direction.x, direction.z)
	elif target:
		var objDirection = (target.global_position - global_position).normalized()
		target_angle = atan2(objDirection.x, objDirection.z)
	target_angle = lerpf(target_angle, atan2(-addedVelocity.x, -addedVelocity.z), addedVelocity.length()/50)
	var new_angle = lerp_angle(rotation.y, target_angle, delta *15)
	rotation.y = new_angle
	velocity = Vector3(0, -1, 0) + (direction+ addedVelocity).normalized() * SPEED
	 
	var collision = move_and_collide(velocity * delta, true)
	if(collision and (collision.get_collider() is Agent or collision.get_collider() is Client)):
		var dir:Vector3 = (collision.get_collider().global_position-global_position).normalized()
		collision.get_collider().bumpedInto(dir * 1.3)
		addedVelocity = dir*-bumpStrength
	move_and_slide()

#
func _process(_delta):
	executeTask()
	fork.visible = eatingState == 1
	knife.visible = eatingState == 1
	
func _ready():
	navAgent.isClient = true
