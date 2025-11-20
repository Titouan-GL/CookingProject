extends Node

class_name GameManager
@export var scoreLabel:Label
@export var scoreLabel2:Label
@export var timeBar:ProgressBar
@export var gameUI:Control
@export var gameOverUI:Control
@export var HowToPlay:Control
@export var Menubutton:Control
var timeLeft;
var initialTime = 180

var score = 0
var displayedScore = 0

func _enter_tree():
	add_to_group("GameManager")
	timeLeft = initialTime
	gameOverUI.visible = false
	gameUI.visible = true
	HowToPlay.visible = false
	Menubutton.visible = true
	
func _process(_delta):
	timeLeft -= _delta
	displayedScore = displayedScore + (score - displayedScore) * _delta * 5
	scoreLabel.text = "Score = " + str(int(roundf(displayedScore)))
	timeBar.value = 100*timeLeft/initialTime
	if(timeLeft < 0):
		gameOverUI.visible = true
		gameUI.visible = false
		scoreLabel2.text = "Score = " + str(int(roundf(displayedScore)))
		get_tree().paused = true
	if Input.is_action_just_pressed("Escape"):
		if HowToPlay.visible :
			get_tree().paused = false
			HowToPlay.visible = false
		else:
			get_tree().paused = true
			HowToPlay.visible = true

func changeScore(val):
	score = max(0, score + val)


func _on_back_from_how_to_play_pressed() -> void:
	get_tree().paused = false
	HowToPlay.visible = false


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
