extends Cook

class_name Player

@export var raycaster:RayCast3D
var hovered:Node3D


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	var target_angle:float = rotation.y
	if direction:
		target_angle = atan2(direction.x, direction.z)
	var planarVelocity = (direction  + addedVelocity).normalized() * SPEED
	velocity = lerp(velocity, Vector3(0, -gravity, 0) + planarVelocity, ACCELERATION*delta)
	target_angle = lerpf(target_angle, atan2(-addedVelocity.x, -addedVelocity.z), addedVelocity.length()/50)
	var new_angle = lerp_angle(rotation.y, target_angle, delta *15)
	rotation.y = new_angle
	
	super._physics_process(delta)
	move_and_slide()
	
	if(raycaster.get_collider()):
		var newhoveredParent = raycaster.get_collider().get_parent()
		var newhovered = raycaster.get_collider()
		if(newhoveredParent is Interactible and newhoveredParent != hovered):
			print(newhoveredParent)
			if hovered:
				hovered.unhovered()
			newhoveredParent.hovered()
			hovered = newhoveredParent
		elif(newhovered is Movable and newhovered != hovered):
			print(newhovered)
			if hovered:
				hovered.unhovered()
			newhovered.hovered()
			hovered = newhovered
		elif newhoveredParent != hovered and newhovered != hovered and hovered:
			hovered.unhovered()
			hovered = null
	else:
		if hovered:
			hovered.unhovered()
			hovered = null

func _init() -> void:
	SPEED = 5
	ACCELERATION = 25
	bumpStrength = 7
	gravity = 20
	friction = 40

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("store"):
		if hovered is Interactible:
			if objectInHand is MovableStorage and hovered.storedObject:
				hovered.storedObject.mix(objectInHand)
			elif objectInHand:
				hovered.store(objectInHand)
			else:
				var obj = hovered.unstore()
				pickUp(obj)
		elif hovered is Movable:
			pickUp(hovered)
		elif hovered == null and objectInHand:
			dropObject()
	if Input.get_action_strength("use"):
		if(hovered is Interactible and hovered.storedObject):
			hovered.use(_delta)
			hovered.usedBy = self
	
func _ready():
	add_to_group("player")
