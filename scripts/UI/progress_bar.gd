extends Node3D

class_name MovableUI

@export var progressViewPort:ViewportTexture
@export var qualityViewPort:ViewportTexture
@export var progressSprite:Sprite3D
@export var qualitySprite:Sprite3D
@export var bar:ProgressBar
@export var star:TextureRect

func _ready():
	progressSprite.texture = progressViewPort
	qualitySprite.texture = qualityViewPort
	qualitySprite.visible = false

func setVisibility(v:bool):
	if progressSprite.visible != v:
		progressSprite.visible = v

func updateBar(value:float):
	bar.value = value

func updateStarLevel(quality:int):
	if quality == 0:
		qualitySprite.visible = false
	elif quality == 1:
		qualitySprite.visible = true
		star.modulate = Color(153/255.0, 125/255.0, 0)
	elif quality == 2:
		qualitySprite.visible = true
		star.modulate = Color(165/255.0, 165/255.0, 165/255.0)
	elif quality == 3:
		qualitySprite.visible = true
		star.modulate = Color(250/255.0, 208/255.0, 0)
