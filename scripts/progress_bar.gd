extends Node3D

@export var viewPort:ViewportTexture
@export var sprite:Sprite3D

func _ready():
	sprite.texture = viewPort
