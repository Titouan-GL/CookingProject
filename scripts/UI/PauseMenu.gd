extends Control

class_name PauseMenu

@export var AgentIcons:Control
@export var MinionsPanel:Control
@export var RecipesPanel:Control
@export var OptionsPanel:Control
@export var AgentButton:Button
@export var agentButtonGroup:ButtonGroup
const inUI = preload("res://scenes/UI/AgentIcon.tscn")
var AgentIconsArray:Array[AgentIcon] = []

func open():
	visible = true
	AgentButton.button_pressed = true
	_on_minions_button_pressed()
	if AgentIconsArray.size() > 0:
		AgentIconsArray[0].button_pressed = true
	
	
func close():
	visible = false

func _ready() -> void:
	MinionsPanel.visible = true
	RecipesPanel.visible = false
	OptionsPanel.visible = false

func addAgentIcon(mesh:Node3D, charName:String = "John Doe"):
	var newIcon:AgentIcon = inUI.instantiate()
	AgentIcons.add_child(newIcon)
	newIcon.init(mesh, charName, AgentIconsArray.size())
	newIcon.button_group = agentButtonGroup
	AgentIconsArray.append(newIcon)


func _on_minions_button_pressed() -> void:
	MinionsPanel.visible = true
	RecipesPanel.visible = false
	OptionsPanel.visible = false


func _on_recipes_button_pressed() -> void:
	MinionsPanel.visible = false
	RecipesPanel.visible = true
	OptionsPanel.visible = false


func _on_options_button_pressed() -> void:
	MinionsPanel.visible = false
	RecipesPanel.visible = false
	OptionsPanel.visible = true
