extends Node3D

@export var sprite:Sprite3D
@export var viewport:ViewportTexture
@export var text:String
@export var label:Label
@export var animPlayer:AnimationPlayer

func _ready():
	sprite.texture = viewport
	label.text = text
	animPlayer.play("hover")
