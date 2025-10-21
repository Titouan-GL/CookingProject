extends Node3D

class_name AgentAnimation

@export var agent: Agent
@export var animationTree: AnimationTree
@export var knife: Node3D
var runningPath:String = "parameters/Running/blend_amount"


func _process(_delta):
	animationTree.set(runningPath, lerp(animationTree.get(runningPath), agent.velocity.length()/agent.SPEED, _delta * 10))
	agent.isCutting = agent.task and \
		agent.order == Enum.Order.USE and \
		agent.nav_agent.is_navigation_finished() and \
		agent.task.destination.taskType == Enum.TaskType.CUT
	knife.visible = agent.isCutting
