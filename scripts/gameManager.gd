extends Node3D

class_name GameManager
@export var scoreLabel:Label

var score = 0
var displayedScore = 0

func _enter_tree():
	add_to_group("GameManager")
	
func _process(_delta):
	displayedScore = displayedScore + (score - displayedScore) * _delta * 5
	scoreLabel.text = "Score = " + str(int(roundf(displayedScore)))

func changeScore(val):
	score = max(0, score + val)
