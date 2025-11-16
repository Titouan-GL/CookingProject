extends Node3D

class_name Hoverable

var defaultMaterials = {}
var overrideMaterials = {}

func findMeshInstances(parent):
	for child in parent.get_children():
		if is_instance_of(child, MeshInstance3D):
			var materials = []
			var override_materials = []
			var i = 0
			var mat:StandardMaterial3D = child.mesh.surface_get_material(i)
			while mat:
				materials.append(mat)
				i+=1
				var overrideMat = mat.duplicate()
				overrideMat.emission_enabled = true
				overrideMat.emission = Color(1, 1, 1)
				overrideMat.emission_energy_multiplier = 0.3
				override_materials.append(overrideMat)
				mat = child.mesh.surface_get_material(i)
			defaultMaterials[child] = materials
			overrideMaterials[child] = override_materials
		findMeshInstances(child)
		
func _enter_tree():
	findMeshInstances(self)
	
func hovered():
	for mesh:MeshInstance3D in overrideMaterials.keys():
		for mats in overrideMaterials.keys():
			for i in range(overrideMaterials[mats].size()):
				mesh.set_surface_override_material(i, overrideMaterials[mats][i])
				
func unhovered():
	for mats in defaultMaterials.keys():
		for i in range(defaultMaterials[mats].size()):
			mats.set_surface_override_material(i, defaultMaterials[mats][i])
