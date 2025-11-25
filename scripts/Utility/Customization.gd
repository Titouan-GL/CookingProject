class_name Customization

const meshes:Dictionary = {
	Enum.CustomizationNames.GlassesRound : preload("res://assets/blender/Customization/GlassesRound.glb"),
	Enum.CustomizationNames.GlassesRectangle : preload("res://assets/blender/Customization/GlassesRectangle.glb"),
	Enum.CustomizationNames.GlassesCat : preload("res://assets/blender/Customization/GlassesCat.glb"),
	Enum.CustomizationNames.MoustacheChevron : preload("res://assets/blender/Customization/Moustache3.glb"),
	Enum.CustomizationNames.MoustachePencil : preload("res://assets/blender/Customization/Moustache4.glb"),
	Enum.CustomizationNames.MoustacheEnglish : preload("res://assets/blender/Customization/Moustache1.glb"),
	Enum.CustomizationNames.MoustacheHorseshoe : preload("res://assets/blender/Customization/Moustache2.glb"),
	Enum.CustomizationNames.PiercingMiddle : preload("res://assets/blender/Customization/PiercingsMiddle.glb"),
	Enum.CustomizationNames.PiercingSide : preload("res://assets/blender/Customization/PiercingsSide.glb"),
}

static func customToMesh(custom:Enum.CustomizationNames) -> PackedScene:
	if(meshes.has(custom)): return meshes[custom]
	return null
