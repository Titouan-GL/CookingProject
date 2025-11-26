extends Node3D

class_name PlayerAnimation

@export var agent: Agent
@export var animationTree: AnimationTree
@onready var knife: Node3D = $Armature/GeneralSkeleton/RightHandAttachment/Knife2
@onready var sponge: Node3D = $Armature/GeneralSkeleton/RightHandAttachment/Sponge
var runningPath:String = "parameters/Running/blend_amount"
@export var particles:GPUParticles3D 
	

func cutImpact():
	particles.emitting = false
	particles.emitting = true

func _process(_delta):
	animationTree.set(runningPath, lerp(animationTree.get(runningPath), agent.velocity.length()/agent.speed, _delta * 10))

	agent.isCutting = false
	agent.isCleaning = false
	if(agent.task and agent.order == Enum.Order.USE and agent.nav_agent.is_navigation_finished() and agent.grabTime <= 0):
		agent.isCutting = agent.task.destination.taskType == Enum.TaskType.CUT
		agent.isCleaning = agent.task.destination.taskType == Enum.TaskType.CLEAN

	knife.visible = agent.isCutting
	sponge.visible = agent.isCleaning
