extends Interactible

func store(i:Movable) -> bool:
	if i is MovableStorage:
		i.empty()
	else:
		i.parent.objectInHand = null
		i.queue_free()
	return true
	
	
func unstore() -> Movable:
	return null
