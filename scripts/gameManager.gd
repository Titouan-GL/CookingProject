extends Node3D

class_name GameManager
@export var scoreLabel:Label
@export var scoreLabel2:Label
@export var timeBar:ProgressBar
@export var gameUI:Control
@export var gameOverUI:Control
var timeLeft;
var initialTime = 120

var score = 0
var displayedScore = 0

func _enter_tree():
	add_to_group("GameManager")
	timeLeft = initialTime
	gameOverUI.visible = false
	gameUI.visible = true
	
func _process(_delta):
	timeLeft -= _delta
	displayedScore = displayedScore + (score - displayedScore) * _delta * 5
	scoreLabel.text = "Score = " + str(int(roundf(displayedScore)))
	timeBar.value = 100*timeLeft/initialTime
	if(timeLeft < 0):
		gameOverUI.visible = true
		gameUI.visible = false
		scoreLabel2.text = "Score = " + str(int(roundf(displayedScore)))
		Engine.time_scale = 0

func changeScore(val):
	score = max(0, score + val)
