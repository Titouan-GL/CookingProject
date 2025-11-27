extends Cook

class_name Player

@export var raycaster:RayCast3D
@export var idealGrabPoint:Node3D
@export var hitArea:Area3D
@export var staffPoint:Node3D
@export var punchEffect:GPUParticles3D
var prevObjectInHand:Node3D
var hovered:Node3D
var inAction:bool = false
var isPunching:bool = false
var punchHitbox:bool = false


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	var target_angle:float = rotation.y
	if direction:
		target_angle = atan2(direction.x, direction.z)
	var planarVelocity = (direction  + addedVelocity).normalized() * speed
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
			#print(newhoveredParent)
			if hovered:
				hovered.unhovered()
			newhoveredParent.hovered()
			hovered = newhoveredParent
		elif(newhovered is Movable and newhovered != hovered):
			#print(newhovered)
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
	speed = 5
	ACCELERATION = 25
	bumpStrength = 7
	gravity = 20
	friction = 40
	dishesSpeed = 1.5
	cuttingSpeed = 1.5
	mixingProficiency = 0.3
	servingProficiency = 0.5
	
func pickUp(obj:Movable):
	if obj:
		prevObjectInHand = obj
		storePoint.global_position = obj.global_position
		super.pickUp(obj)
		
func _process(_delta: float) -> void:
	if(objectInHand):
		storePoint.global_position = lerp(storePoint.global_position, idealGrabPoint.global_position, _delta*10)
	elif prevObjectInHand:
		storePoint.global_position = prevObjectInHand.global_position
	
	if punchHitbox:
		var bodies = hitArea.get_overlapping_bodies()
		for b in bodies:
			if b is Agent:
				var dir:Vector3 = (b.global_position-global_position).normalized()
				b.bumpedInto(dir*3)
				if punchEffect:
					punchEffect.global_position = staffPoint.global_position
					punchEffect.emitting = true
	
	if Input.is_action_just_pressed("store"):
		if hovered is Interactible:
			if objectInHand is MovableStorage and hovered.storedObject:
				hovered.storedObject.mix(objectInHand, mixingProficiency)
			elif objectInHand:
				if hovered is ClientTable:
					objectInHand.increaseQuality(servingProficiency)
				hovered.store(objectInHand, mixingProficiency)
			else:
				var obj = hovered.unstore()
				pickUp(obj)
		elif hovered is Movable:
			pickUp(hovered)
		elif hovered == null and objectInHand:
			dropObject()
	inAction = false
	if Input.get_action_strength("use"):
		if(not objectInHand and hovered is Interactible and hovered.storedObject):
			inAction = true
			if hovered is IntSink:
				hovered.use(_delta * dishesSpeed)
			elif hovered is IntCutter:
				hovered.use(_delta * cuttingSpeed)
			else:
				hovered.use(_delta)
			hovered.usedBy = self
		elif Input.is_action_just_pressed("use") and not objectInHand:
			isPunching = true
			await get_tree().create_timer(0.4).timeout
			punchHitbox = true
			await get_tree().create_timer(0.1).timeout
			isPunching = false
			punchHitbox = false

func check_sphere_collision(pos: Vector3, radius: float):
	var space_state = get_world_3d().direct_space_state
	var shape = SphereShape3D.new()
	shape.radius = radius
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(Basis(), pos)
	query.collision_mask = 2  # choose your mask
	var results = space_state.intersect_shape(query)
	return results


func _ready():
	add_to_group("player")
	storePoint.call_deferred("reparent", get_tree().current_scene)
