extends CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var target_node_path: NodePath  
@export var grabPoint: Node3D  
@export var ingredient: Ingredient  
@export var cuttingtable: Node3D
@export var SPEED: int = 3
@export var CARRY_SPEED: int = 3
var objectInHand:Node3D

func find_nearest_ingredient() -> Ingredient:
	var nearest: Ingredient = null
	var shortest_distance := INF

	for node in get_tree().get_nodes_in_group("rawIngredients"):
		if node is Ingredient:
			var dist := global_position.distance_to(node.global_position)
			if dist < shortest_distance:
				shortest_distance = dist
				nearest = node

	return nearest

func cutIngredient():
	if(not objectInHand):
		if(not ingredient):
			ingredient = find_nearest_ingredient()
		if(ingredient):
			nav_agent.set_target_position(ingredient.position)
			if(nav_agent.is_navigation_finished()):
				objectInHand = ingredient
				objectInHand.pickedUp(grabPoint)
	else:
		nav_agent.set_target_position(cuttingtable.position)
		if(nav_agent.is_navigation_finished()):
			objectInHand.change_mesh_color()
			objectInHand.dropped()
			objectInHand = null
			ingredient = null

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return

	var next_path_position = nav_agent.get_next_path_position()

	var direction = (next_path_position - global_position).normalized()
	var target_angle = atan2(direction.x, direction.z)
	var current_angle = rotation.y
	var new_angle = lerp_angle(current_angle, target_angle, delta *10 )
	rotation.y = new_angle
	var current_speed
	if objectInHand:
		current_speed = CARRY_SPEED
	else:
		current_speed = SPEED
	velocity = direction * current_speed
	move_and_slide()

func _process(delta):
	cutIngredient()
