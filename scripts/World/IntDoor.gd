extends Interactible
class_name IntDoor

@export var timer = 1
@export var playerLimit = -1
const client = preload("res://scenes/client.tscn")
var override #= [2, 3, 4, 2, 1, 3, 4]

func _init():
	add_to_group("IntDOOR")
	passive = true
	obstacle = false

func generateClient():
	var inst = client.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_transform = global_transform
	if(override and override.size() > 0):
		inst.target = get_tree().get_nodes_in_group("servePoint")[override[0]-1]
		inst.updateTarget()
		override.remove_at(0)

func _process(_delta):
	timer -= _delta
	if(timer < 0 and playerLimit != 0):
		timer = 7
		if(get_tree().get_nodes_in_group("freeServePoint")):
			playerLimit -= 1
			generateClient()
