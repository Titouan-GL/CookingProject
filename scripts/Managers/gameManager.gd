extends Node

class_name GameManager
var mainScoreLabel:Label
var timeBar:ProgressBar
var gameUI:Control
var gameOverUI:Control
var pauseMenu:PauseMenu
@export var clientsPatience:bool = false
@export var recipeOverride:Array[Enum.RecipeNames] #= [Enum.RecipeNames.BurSteSal, Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.BurSteSalTom, Enum.RecipeNames.BurSteSalTom, Enum.RecipeNames.CutTomCutSal, Enum.RecipeNames.BurSteSalTom]
@export var timerEnabled:bool = true
@export var displayFinalScore:bool = true
@export var recipesOption:Array[Enum.RecipeNames]
var finalScoreLabel
var clientServed = 0

var timeLeft;
var initialTime = 180

var score = 0
var displayedScore = 0
	

func _ready() -> void:
	finalScoreLabel = $EndScreen/VBoxContainer/FinalScoreLabel
	finalScoreLabel.visible = displayFinalScore
	mainScoreLabel = $Score/MarginContainer/ProgressBar/MainScoreLabel
	timeBar = $Score/MarginContainer/ProgressBar
	gameUI = $Score
	gameUI.visible = timerEnabled
	gameOverUI = $EndScreen
	gameOverUI.visible = false
	pauseMenu = $PauseMenu
	pauseMenu.close()

func _enter_tree():
	add_to_group("GameManager")
	timeLeft = initialTime

func addAgentIcon(agent:Agent, mesh:Node3D, charName:String = "John Doe"):
	pauseMenu.addAgentIcon(agent, mesh, charName)

func endGame():
	gameOverUI.visible = true
	gameUI.visible = false
	finalScoreLabel.text = "Score = " + str(int(roundf(displayedScore)))
	get_tree().paused = true
	
func _process(_delta):
	if not get_tree().paused and timerEnabled:
		timeLeft -= _delta
	displayedScore = displayedScore + (score - displayedScore) * _delta * 5
	mainScoreLabel.text = "Score = " + str(int(roundf(displayedScore)))
	timeBar.value = 100*timeLeft/initialTime
	if(timeLeft < 0):
		endGame()
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
