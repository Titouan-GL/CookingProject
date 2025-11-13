extends Node3D

class_name IngredientIcon

@export var viewPort:ViewportTexture
@export var sprite3D:Sprite3D
@export var sprite2D:Sprite2D

func _ready():
	sprite3D.texture = viewPort

func UpdateAppearance(recipe):
	var newTex = Recipes.recipeToTexture(recipe)
	if(newTex):
		sprite2D.texture = newTex
