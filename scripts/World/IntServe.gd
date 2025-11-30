extends Interactible
class_name IntServe

var hierarchy:Hierarchy
var recipeWanted:Enum.RecipeNames = Enum.RecipeNames.Empty
@export var icon:IngredientIcon
@export var progressBar:MovableUI
@export var destinationPoint:Node3D
@export var available:bool
var gameManager:GameManager
var client:Client = null
var navmesh:Navigation
@export var particles:GPUParticles3D
var table:ClientTable
var qualityMultiplier:Dictionary = {0:1, 1:1.2, 2:1.5, 3:2}

var timeLeft = 0
var initialTime = 45

func _enter_tree():
	super._enter_tree()
	if(available) : 
		add_to_group("freeServePoint")
		add_to_group("servePoint")
	destinationPoint.visible = available

func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true
	obstacle = false

func newRecipe():
	if(gameManager.recipeOverride and gameManager.recipeOverride.size() > 0):
		recipeWanted = gameManager.recipeOverride[0]
		gameManager.recipeOverride.remove_at(0)
	else:
		recipeWanted = gameManager.recipesOption.pick_random()
		#recipeWanted = Enum.RecipeNames.TomatoSoup
	timeLeft = initialTime
	icon.UpdateAppearance(recipeWanted)

func reserved(c:Client):
	remove_from_group("freeServePoint")
	client = c

func clientSat():
	hierarchy.servePoints.append(self)
	navmesh.addObstacle(destinationPoint, true)

func clientLeft():
	particles.emitting = false
	navmesh.removeObstacle(destinationPoint)


func _ready():
	navmesh = get_tree().get_first_node_in_group("navmesh")
	navmesh.addObstacle(self)
	super._ready()
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	gameManager = get_tree().get_nodes_in_group("GameManager")[0]


func serve(success:bool, quality:int = 0):
	hierarchy.servePoints.erase(self)
	if(success):
		particles.emitting = true
		gameManager.clientServed += 1
		gameManager.changeScore(Recipes.getScore(recipeWanted) * qualityMultiplier[quality])
		client.changeState(1)
		recipeWanted = Enum.RecipeNames.Empty
		await get_tree().create_timer(3.0).timeout
		if storedObject is Plate:
			storedObject.mealFinished()
			if table.ishovered:
				table.hovered()
	else:
		particles.emitting = false
		add_to_group("freeServePoint")
		gameManager.changeScore(-Recipes.getScore(recipeWanted))
		recipeWanted = Enum.RecipeNames.Empty
		
	client.changeState(2) 
	client = null
	clientLeft()

func unstore() ->Movable:
	add_to_group("freeServePoint")
	return super.unstore()

func store(i:Movable, _proba:float = 0) -> bool:
	i.increaseQuality(_proba)
	if i is Plate:
		i.served()
	i.parent.objectInHand = null
	i.parent = self
	storedObject = i
	serve(true, i.quality)
	return true

func _process(_delta):
	if(recipeWanted == Enum.RecipeNames.Empty):
		progressBar.setVisibility(false)
		icon.visible = false
	else:
		icon.visible = true
		if not gameManager.clientsPatience:
			progressBar.setVisibility(true)
			timeLeft -= _delta
		if(timeLeft < 0):
			serve(false)
		else:
			if not gameManager.clientsPatience:
				progressBar.updateBar(timeLeft/initialTime)
				progressBar.setVisibility(true)
