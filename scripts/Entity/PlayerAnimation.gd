extends Node3D

class_name AgentAnimation

@export var player: Player
@export var animationTree: AnimationTree
#@export var knife: Node3D
#@export var sponge: Node3D
var runningPath:String = "parameters/Running/blend_amount"
@export var beamParticles:GPUParticles3D 
@export var powerParticles:GPUParticles3D 
@export var impactParticles:GPUParticles3D 
@export var grabPoint:Node3D
@export var staffPoint:Node3D
@export var knifeAnimation:AnimationPlayer
@export var knife:Node3D
@export var spongeAnimation:AnimationPlayer
@export var sponge:Node3D
var particleTrail:ShaderMaterial
var inAction:bool

func _ready():
	particleTrail = beamParticles.process_material
	knifeAnimation.play("knifeCut")
	spongeAnimation.play("SpongeAnim")

func setBeamPos():
		var packedArray:PackedVector3Array = particleTrail.get_shader_parameter("points")
		var basisRotation  = global_transform.basis.get_rotation_quaternion()
		basisRotation.x = -basisRotation.x
		basisRotation.w = -basisRotation.w
		var staffPos =  basisRotation * (staffPoint.global_position - global_position)
		var grabPos = basisRotation * (grabPoint.global_position - global_position) - Vector3(0, 0.1, 0)
		packedArray[2] = grabPos
		packedArray[1] = Vector3(grabPos.x, staffPos.y, grabPos.z)
		packedArray[0] = staffPos
		particleTrail.set_shader_parameter("Points", packedArray)

func cutImpact():
	impactParticles.emitting = true

func _process(_delta):
	inAction = player.inAction
	animationTree.set(runningPath, lerp(animationTree.get(runningPath), player.velocity.length()/player.SPEED, _delta * 10))
	setBeamPos()
	if player.objectInHand:
		beamParticles.emitting = true
	else:
		beamParticles.emitting = false
	
	knife.visible = false
	sponge.visible = false
	powerParticles.emitting = false
	if inAction :
		if player.hovered is IntCutter:
			knife.visible = true
			powerParticles.emitting = true
			knife.global_position = player.hovered.storePoint.global_position
			knife.global_rotation = player.hovered.storePoint.global_rotation
		if player.hovered is IntSink:
			sponge.visible = true
			powerParticles.emitting = true
			sponge.global_position = player.hovered.storePoint.global_position
			sponge.global_rotation = player.hovered.storePoint.global_rotation
