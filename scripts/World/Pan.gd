extends MovableStorage
class_name Pan

@export var particles:GPUParticles3D 

func increaseQualityCooking(_proba:float):
	if recipe == Enum.RecipeNames.PanCutSte and not cookingImproved:
		cookingImproved = false
		increaseQuality(_proba)

func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.PanCutSte):
		if(progress.has(s)):
			progress[s] -= delta
			progressBar.updateBar(1-(progress[s]/progressMaxValues[s]))
			if(progress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					particles.emitting = true
					cook()
				return true
	return false

func canEmpty()->bool:
	return recipe == Enum.RecipeNames.PanCookCutSte



func _enter_tree():
	groupName = "PanEMPTY"
	emptyName = Enum.RecipeNames.EmptyPan
	progressMaxValues = {Enum.TaskType.COOK:3}
	super._enter_tree()
