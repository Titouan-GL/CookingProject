extends CharacterBody3D

class_name Character

var SPEED
var ACCELERATION
var addedVelocity = Vector3.ZERO
var bumpStrength:float
var gravity:float
var friction:float
var space:PhysicsDirectSpaceState3D

func bumpedInto(dir:Vector3):
	var orthogonal = Vector3(dir.z , 0, -dir.x ).normalized()/2
	var mask = 1 << 0
	var query
	var result
	var dist
	var best_result = null
	var best_dest = null
	for dest in [dir, -dir*0.7, orthogonal, -orthogonal]:
		query = PhysicsRayQueryParameters3D.create(global_position, global_position+dest*2 , mask)
		result = space.intersect_ray(query)
		if(result):
			dist = (global_position - result.position).length()
			if not best_result or dist > (global_position - best_result.position).length():
				best_result = result
				best_dest = dest
		else:
			addedVelocity = dest*bumpStrength
			return
	var random_vector = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	addedVelocity = random_vector*bumpStrength/3 + best_dest*bumpStrength

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
		collision.get_collider().bumpedInto(dir * 1.3)
		addedVelocity = dir*-bumpStrength
