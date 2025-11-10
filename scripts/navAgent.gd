extends Node3D

class_name NavAgent
var target_position:Vector3
var target = null
var navFinished = false
var navmesh:Navigation

func set_target_position(p):
	target_position = p

func is_navigation_finished():
	return navFinished

func get_next_path_position():
	var nextPos = navmesh.getNextPosition(self.global_position, target_position)
	navFinished = nextPos == null
	if navFinished:
		return global_position
	else:
		return nextPos

func _ready():
	navmesh = get_tree().get_nodes_in_group("navmesh")[0]
