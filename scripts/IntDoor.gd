extends Interactible
class_name IntDoor

var timer = 1
const client = preload("res://scenes/client.tscn")

func _init():
	add_to_group("IntDOOR")
	passive = true
	obstacle = false

func generateClient():
	var inst = client.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_transform = global_transform

func _process(_delta):
	if(get_tree().get_nodes_in_group("freeServePoint")):
		timer -= _delta
		if(timer < 0):
			timer = 30
			generateClient()
