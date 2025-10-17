extends MeshInstance3D
@export var target_path: NodePath

var target_node: Node3D

func _ready():
	target_node = get_node(target_path)

func _process(delta):
	if target_node:
		global_position = Vector3(target_node.global_position)
		
