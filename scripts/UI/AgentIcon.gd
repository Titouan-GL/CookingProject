extends Button

class_name AgentIcon

@export var agentInUI:Node3D
@export var nameDisplay:Label

func changeLayerRecursive(n:Node):
	for child in n.get_children():
		if child is VisualInstance3D:
			child.set_layer_mask_value(1, false)
			child.set_layer_mask_value(20, true)
		changeLayerRecursive(child)

func init(mesh:Node3D, charName:String, index:int):
	var newMesh = mesh.duplicate()
	newMesh.reset_bone_poses()
	agentInUI.add_child(newMesh)
	newMesh.position = Vector3(0,0,0)
	newMesh.rotation = Vector3(0,0,0)
	changeLayerRecursive(newMesh)
	agentInUI.global_position = Vector3(index*3, -100, 0)
	nameDisplay.text = charName
