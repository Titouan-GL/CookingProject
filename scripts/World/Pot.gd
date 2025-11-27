extends MovableStorage
class_name Pot
@export var mesh:MeshInstance3D
@export var particles:GPUParticles3D

func increaseQualityCooking(_proba:float):
	if recipe == Enum.RecipeNames.PotCutTomCutTomCutTom and not cookingImproved:
		cookingImproved = false
		increaseQuality(_proba)

func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.PotCutTomCutTomCutTom):
		if(progress.has(s)):
			progressBar.updateBar(1-(progress[s]/progressMaxValues[s]))
			progress[s] -= delta
			if(progress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					particles.emitting = true
					cook()
				return true
	return false

func canEmpty()->bool:
	return recipe == Enum.RecipeNames.TomatoSoup


func _enter_tree():
	groupName = "PotEMPTY"
	emptyName = Enum.RecipeNames.EmptyPot
	progressMaxValues = {Enum.TaskType.COOK:3}
	super._enter_tree()
