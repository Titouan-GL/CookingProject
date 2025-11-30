extends Control

class_name PauseMenu

@export var AgentIcons:Control
@export var MinionsPanel:Control
@export var RecipesPanel:Control
@export var OptionsPanel:Control
@export var AgentButton:Button
@export var agentButtonGroup:ButtonGroup
@export var skeletonNameLabel:Label
@export var speedBar:ProgressBar
@export var dishesBar:ProgressBar
@export var cuttingBar:ProgressBar
@export var MixingBar:ProgressBar
@export var ServingBar:ProgressBar
@export var checkButtons:Dictionary[Enum.TaskType, CheckBox]
@export var recipeTexture:TextureRect
@export var recipeNameLabel:Label
@export var defaultRecipeButton:Button
const inUI = preload("res://scenes/UI/AgentIcon.tscn")
var AgentIconsArray:Dictionary[AgentIcon, Agent]
var currentIcon:AgentIcon
const recipesDisplay:Dictionary = {
	Enum.RecipeNames.BurSteSalTom:["Tomato Burger", preload("res://assets/textures/BurSteSalTomRecipe.png")],
	Enum.RecipeNames.BurSteSal:["Burger", preload("res://assets/textures/BurSteSalRecipe.png")],
	Enum.RecipeNames.TomatoSoup:["Tomato Soup", preload("res://assets/textures/tomatoSoupRecipe.png")],
	Enum.RecipeNames.CutTomCutSal:["Tomato Salad", preload("res://assets/textures/tomatoSaladRecipe.png")],
}


func open():
	visible = true
	AgentButton.button_pressed = true
	_on_minions_button_pressed()
	if AgentIconsArray.size() > 0:
		openAgentIcon(AgentIconsArray.keys()[0])
	_on_bur_ste_sal_tom_button_pressed()
	defaultRecipeButton.button_pressed = true
	
func close():
	visible = false

func _ready() -> void:
	MinionsPanel.visible = true
	RecipesPanel.visible = false
	OptionsPanel.visible = false

func addAgentIcon(agent:Agent, mesh:Node3D, charName:String = "John Doe"):
	var newIcon:AgentIcon = inUI.instantiate()
	AgentIcons.add_child(newIcon)
	newIcon.init(mesh, charName, AgentIconsArray.size())
	newIcon.button_group = agentButtonGroup
	AgentIconsArray[newIcon] = agent

func updateAgentDisplay():
	var agent = AgentIconsArray[currentIcon]
	for task in checkButtons.keys():
		if task in agent.prohibitedTasks:
			checkButtons[task].button_pressed = false
		else:
			checkButtons[task].button_pressed = true

func openAgentIcon(icon:AgentIcon):
	currentIcon = icon
	var agent = AgentIconsArray[icon]
	icon.button_pressed = true
	skeletonNameLabel.text = agent.characterName
	speedBar.value = 100*(agent.speed - agent.speedRange.x)/(agent.speedRange.z-agent.speedRange.x)
	dishesBar.value = 100*(agent.dishesSpeed - agent.dishesRange.x)/(agent.dishesRange.z-agent.dishesRange.x)
	cuttingBar.value = 100*(agent.cuttingSpeed - agent.cuttingRange.x)/(agent.cuttingRange.z - agent.cuttingRange.x)
	MixingBar.value = 100*(agent.mixingProficiency - agent.mixingRange.x)/(agent.mixingRange.z-agent.mixingRange.x)
	ServingBar.value = 100*(agent.servingProficiency - agent.servingRange.x)/(agent.servingRange.z - agent.servingRange.x)
	updateAgentDisplay()


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

func _process(_delta: float):
	if agentButtonGroup.get_pressed_button() and agentButtonGroup.get_pressed_button() != currentIcon:
		openAgentIcon(agentButtonGroup.get_pressed_button())


func _on_cut_box_toggled(toggled_on: bool) -> void:
	var agent = AgentIconsArray[currentIcon]
	if toggled_on:
		agent.allowTask(Enum.TaskType.CUT)
	else:
		agent.prohibitTask(Enum.TaskType.CUT)
		


func _on_clean_box_toggled(toggled_on: bool) -> void:
	var agent = AgentIconsArray[currentIcon]
	if toggled_on:
		agent.allowTask(Enum.TaskType.CLEAN)
	else:
		agent.prohibitTask(Enum.TaskType.CLEAN)


func _on_mix_box_toggled(toggled_on: bool) -> void:
	var agent = AgentIconsArray[currentIcon]
	if toggled_on:
		agent.allowTask(Enum.TaskType.MIX)
	else:
		agent.prohibitTask(Enum.TaskType.MIX)


func _on_serve_box_toggled(toggled_on: bool) -> void:
	var agent = AgentIconsArray[currentIcon]
	if toggled_on:
		agent.allowTask(Enum.TaskType.EMPTY)
	else:
		agent.prohibitTask(Enum.TaskType.EMPTY)

func changeDisplayedRecipe(recipe:Enum.RecipeNames):
	recipeTexture.texture = recipesDisplay[recipe][1]
	recipeNameLabel.text = recipesDisplay[recipe][0]
	

func _on_bur_ste_sal_tom_button_pressed() -> void:
	changeDisplayedRecipe(Enum.RecipeNames.BurSteSalTom)


func _on_bur_ste_sal_button_pressed() -> void:
	changeDisplayedRecipe(Enum.RecipeNames.BurSteSal)


func _on_tomato_soup_button_pressed() -> void:
	changeDisplayedRecipe(Enum.RecipeNames.TomatoSoup)


func _on_tomato_salad_button_pressed() -> void:
	changeDisplayedRecipe(Enum.RecipeNames.CutTomCutSal)


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
