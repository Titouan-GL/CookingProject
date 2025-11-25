extends Node3D

class_name ClientAnimation

@export var client: Client
@export var animationTree: AnimationTree
var runningPath:String = "parameters/Running/blend_amount"


func _process(_delta):
	animationTree.set(runningPath, lerp(animationTree.get(runningPath), client.velocity.length()/client.SPEED, _delta * 10))
