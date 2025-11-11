extends Node3D

class_name NavAgent
var target_position:Vector3
var navFinished = false
var navmesh:Navigation
var isClient = false

func set_target_position(p):
	target_position = p
	navFinished = navmesh.getNextPosition(global_position, target_position, isClient) == null

func is_navigation_finished():
	return navFinished or distance_to_target() < 0.6

func distance_to_target():
	return (global_position - target_position).length()

func get_target_on_grid():
	return navmesh.posToGrid(target_position)

func get_next_path_position():
	var nextPos = navmesh.getNextPosition(global_position, target_position, isClient)
	navFinished = nextPos == null
	if navFinished:
		return global_position
	else:
		return nextPos

func _ready():
	navmesh = get_tree().get_nodes_in_group("navmesh")[0]
