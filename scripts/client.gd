extends CharacterBody3D
class_name Client
const SPEED = 3
var addedVelocity:Vector3 = Vector3.ZERO
var friction:float = 40
var bumpStrength:float = 3
var target:Node3D = null
var eatingState = 0 #1 if currently eating, 2 if already eaten
var navmesh:Navigation
var next_path_position


func executeTask():
	if eatingState == 0 :
		if target == null:
			target = get_tree().get_nodes_in_group("freeServePoint").pick_random()
		elif next_path_position == null and target.recipeWanted == Enum.RecipeNames.Empty :
			target.newRecipe()
			target.clientSat(self)
	if eatingState == 2:
		if target == null:
			target = get_tree().get_nodes_in_group("IntDOOR").pick_random()
		elif next_path_position == null:
			queue_free()

func changeState(v):
	target = null
	eatingState = v

func bumpedInto(dir:Vector3):
	addedVelocity = dir*bumpStrength

func _physics_process(delta):
	if(addedVelocity.length() > 0):
		var reduction = friction*delta
		addedVelocity -= addedVelocity.normalized() * reduction
		if(addedVelocity.length() < reduction ):
			addedVelocity = Vector3.ZERO
	
	var direction:Vector3 = Vector3.ZERO
	var target_angle:float = rotation.y
	next_path_position = null
	if(target is IntServe): next_path_position = navmesh.getNextPosition(self, target.destinationPoint)
	elif(target is IntDoor): next_path_position = navmesh.getNextPosition(self, target)
	if(next_path_position != null):
		direction = (next_path_position - global_position).normalized()
		target_angle = atan2(direction.x, direction.z)
	elif target:
		var objDirection = (target.global_position - global_position).normalized()
		target_angle = atan2(objDirection.x, objDirection.z)
	target_angle = lerpf(target_angle, atan2(-addedVelocity.x, -addedVelocity.z), addedVelocity.length()/50)
	var new_angle = lerp_angle(rotation.y, target_angle, delta *15)
	rotation.y = new_angle
	velocity = (direction+ addedVelocity).normalized() * SPEED 
	move_and_slide()

#
func _process(_delta):
	executeTask()

func _ready():
	navmesh = get_tree().get_first_node_in_group("navmesh")
