extends Node3D

class_name AgentAnimation

@export var player: Player
@export var animationTree: AnimationTree
#@export var knife: Node3D
#@export var sponge: Node3D
var runningPath:String = "parameters/Running/blend_amount"


func _process(_delta):
	animationTree.set(runningPath, lerp(animationTree.get(runningPath), player.velocity.length()/player.SPEED, _delta * 10))
	
	#agent.isCutting = false
	#agent.isCleaning = false
	#if(agent.task and agent.order == Enum.Order.USE and agent.nav_agent.is_navigation_finished() and agent.grabTime <= 0):
		#agent.isCutting = agent.task.destination.taskType == Enum.TaskType.CUT
		#agent.isCleaning = agent.task.destination.taskType == Enum.TaskType.CLEAN
#
	#knife.visible = agent.isCutting
	#sponge.visible = agent.isCleaning
