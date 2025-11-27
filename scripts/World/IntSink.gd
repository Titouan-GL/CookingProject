extends Interactible

class_name IntSink
@export var particles:GPUParticles3D
@export var anim:AnimationPlayer
var isFilled:bool = false

func setIsFilled(b:bool):
	isFilled = b

func _init():
	taskType = Enum.TaskType.CLEAN
	passive = false

func store(i:Movable, _proba:float = 0) -> bool:
	if(!storedObject and i is Plate and i.dirty):
		i.parent.objectInHand = null
		storedObject = i
		storedObject.pickUp(self)
		if ishovered : hovered()
		return true
	return false

func unstore() ->Movable:
	if isFilled:
		particles.emitting = false
		anim.play("Empty")
	return super.unstore()

func use(delta:float):
	if storedObject and storedObject.progress[taskType] > 0:
		if not isFilled:
			particles.emitting = true
			anim.play("Fill")
	if super.use(delta):
		if isFilled:
			particles.emitting = false
			anim.play("Empty")
		return true
	return false
