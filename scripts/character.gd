extends CharacterBody3D

class_name Character

var SPEED
var ACCELERATION
var addedVelocity = Vector3.ZERO
var bumpStrength:float
var gravity:float
var friction:float
var space:PhysicsDirectSpaceState3D

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
			
	var collision = move_and_collide(Vector3(velocity.x, 0, velocity.z)*delta, true)
	if(collision and collision.get_collider() is Character):
		var dir:Vector3 = (collision.get_collider().global_position-global_position).normalized()
		collision.get_collider().bumpedInto(dir * 1.5, -get_global_transform().basis.x)
		bumpedInto(-dir, -get_global_transform().basis.x)
