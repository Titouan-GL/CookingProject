extends Interactible

@export var anim:AnimationPlayer

func store(i:Movable, _proba:float= 0) -> bool:
	if i is MovableStorage:
		i.empty()
		anim.play("Trash")
	else:
		anim.play("Trash")
		i.parent.objectInHand = null
		i.queue_free()
	return true
	
	
func unstore() -> Movable:
	return null
