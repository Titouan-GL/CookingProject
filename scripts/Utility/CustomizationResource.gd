extends Resource

class_name CustomizationResource

@export var dic:Dictionary[Enum.CustomizationNames, float]

func pick_random() -> Enum.CustomizationNames:
	var tot = 0
	for i in dic.values():
		tot += i
	var v = randf_range(0.0, tot)
	for i in dic.keys():
		if v < dic[i]:
			return i
		else:
			v -= dic[i]
	return Enum.CustomizationNames.None
