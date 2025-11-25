extends CharacterBody3D

class_name Character

var SPEED
var ACCELERATION
var addedVelocity = Vector3.ZERO
var bumpStrength:float
var gravity:float
var friction:float
var space:PhysicsDirectSpaceState3D
@export var pushEffect:GPUParticles3D
@export var characterName:String

@export var customOption:Dictionary[CustomizationResource, Node3D]
var currentOptions:Dictionary[Enum.CustomizationNames, Node3D]

func CreateAppearance():
	for i in customOption:
		var newDeco = i.pick_random()
		if newDeco != Enum.CustomizationNames.None:
			currentOptions[newDeco] = customOption[i]

func UpdateAppearance():
	for deco in currentOptions.keys():
		var newMesh:Node = Customization.customToMesh(deco).instantiate()
		currentOptions[deco].add_child(newMesh)
		newMesh.set_position(Vector3.ZERO)
		#newMesh.set_rotation(Vector3.ZERO)

func bumpedInto(dir:Vector3, rightVector:Vector3 = Vector3(0,0,0)):
	if rightVector != Vector3(0,0,0):
		var right = rightVector*dir.length()*bumpStrength/3
		if right.dot(dir) > 0:
			addedVelocity = dir*bumpStrength + right
		else:
			addedVelocity = dir*bumpStrength - right
	else:
		addedVelocity = dir*bumpStrength

func _enter_tree() -> void:
	space = get_world_3d().direct_space_state

func _physics_process(delta: float) -> void:
	if(addedVelocity.length() > 0):
		var reduction = friction*delta
		addedVelocity -= addedVelocity.normalized() * reduction
		if(addedVelocity.length() < reduction ):
			addedVelocity = Vector3.ZERO
			
	var collision:KinematicCollision3D = move_and_collide(Vector3(velocity.x, 0, velocity.z)*delta, true)
	if(collision and collision.get_collider() is Character):
		var dir:Vector3 = (collision.get_collider().global_position-global_position).normalized()
		collision.get_collider().bumpedInto(dir * 1.5, -get_global_transform().basis.x)
		bumpedInto(-dir, -get_global_transform().basis.x)
		
		if pushEffect:
			pushEffect.global_position = collision.get_position()
			pushEffect.emitting = true
