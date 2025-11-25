extends Node3D

class_name Hoverable

var defaultMaterials:Dictionary[Node3D, Array] = {}
var overrideMaterials:Dictionary[Node3D, Array] = {}
@export var hoverSearch:Node3D
var ishovered = false

func findMeshInstances(parent):
	for child in parent.get_children():
		if is_instance_of(child, MeshInstance3D):
			var materials = []
			var override_materials = []
			var i = 0
			var mat:StandardMaterial3D
			while i < child.mesh.get_surface_count():
				mat = child.mesh.surface_get_material(i)
				materials.append(mat)
				var overrideMat = mat.duplicate()
				overrideMat.emission_enabled = true
				overrideMat.emission = Color(1, 1, 1)
				overrideMat.emission_energy_multiplier = 0.03
				override_materials.append(overrideMat)
				i+=1
			defaultMaterials[child] = materials
			overrideMaterials[child] = override_materials
		findMeshInstances(child)


func _enter_tree():
	if(hoverSearch):
		findMeshInstances(hoverSearch)
	else:
		findMeshInstances(self)

func resetMeshes():
	var newDefaultMaterials:Dictionary[Node3D, Array] = {}
	var newOverrideMaterials:Dictionary[Node3D, Array] = {}
	
	for mats in defaultMaterials.keys():
		if is_instance_valid(mats):
			newDefaultMaterials[mats] = defaultMaterials[mats]
	for mats in overrideMaterials.keys():
		if is_instance_valid(mats):
			newOverrideMaterials[mats] = overrideMaterials[mats]
	defaultMaterials = newDefaultMaterials
	overrideMaterials = newOverrideMaterials
	
	

func hovered():
	var invalidElements = 0
	if not ishovered:
		for mats in overrideMaterials.keys():
			if is_instance_valid(mats):
				for i in range(overrideMaterials[mats].size()):
					mats.set_surface_override_material(i, overrideMaterials[mats][i])
			else:
				invalidElements += 1
	ishovered = true
	if(invalidElements > 0):
		resetMeshes()

func unhovered():
	var invalidElements = 0
	if ishovered:
		for mats in defaultMaterials.keys():
			if is_instance_valid(mats):
				for i in range(defaultMaterials[mats].size()):
					mats.set_surface_override_material(i, defaultMaterials[mats][i])
			else:
				invalidElements += 1
	ishovered = false
	if(invalidElements > 0):
		resetMeshes()
