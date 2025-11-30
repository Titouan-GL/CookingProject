extends Node3D

class_name NavAgent
var target_position:Vector3
var navFinished = false
var navmesh:Navigation
var isClient = false
var distance_wanted = 1.0

func set_target_position(p):
	target_position = p
	navFinished = navmesh.getNextPosition(global_position, target_position, isClient) == null or distance_to_target() < distance_wanted

func is_navigation_finished():
	return navmesh.getNextPosition(global_position, target_position, isClient) == null or distance_to_target() < distance_wanted 

func get_full_path():
	return navmesh.get_full_path(global_position, target_position, isClient)
	
func distance_to_target():
	return (global_position - target_position).length()

func get_target_on_grid():
	return navmesh.posToGrid(target_position)
	
func is_target_reachable():
	return navmesh.get_full_path(global_position, target_position, isClient).size() > 0

func try_target_reachable(global_pos, target_pos, isclient):
	return navmesh.get_full_path(global_pos, target_pos, isclient).size() > 0

func get_next_path_position():
	var nextPos = navmesh.getNextPosition(global_position, target_position, isClient)
	navFinished = nextPos == null or distance_to_target() < distance_wanted
	if navFinished:
		return global_position
	else:
		return nextPos

func _ready():
	navmesh = get_tree().get_nodes_in_group("navmesh")[0]
