extends Node

class_name GameManager
@export var scoreLabel:Label
@export var scoreLabel2:Label
@export var timeBar:ProgressBar
@export var gameUI:Control
@export var gameOverUI:Control
@export var Menubutton:Control
@export var pauseMenu:PauseMenu
var timeLeft;
var initialTime = 180

var score = 0
var displayedScore = 0

func _enter_tree():
	add_to_group("GameManager")
	timeLeft = initialTime
	gameOverUI.visible = false
	gameUI.visible = true
	pauseMenu.close()
	if Menubutton:
		Menubutton.visible = true

func addAgentIcon(agent:Agent, mesh:Node3D, charName:String = "John Doe"):
	pauseMenu.addAgentIcon(agent, mesh, charName)

func _process(_delta):
	if not get_tree().paused:
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
		if pauseMenu.visible :
			get_tree().paused = false
			pauseMenu.close()
		else:
			get_tree().paused = true
			pauseMenu.open()

func changeScore(val):
	score = max(0, score + val)


func _on_back_from_how_to_play_pressed() -> void:
	get_tree().paused = false
	pauseMenu.close()


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
