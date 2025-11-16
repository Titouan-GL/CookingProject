extends Interactible
class_name IntServe

var hierarchy:Hierarchy
var recipeWanted:Enum.RecipeNames = Enum.RecipeNames.Empty
@export var icon:IngredientIcon
@export var progressBar:ProgressBar
@export var destinationPoint:Node3D
@export var available:bool
var gameManager:GameManager
var client:Client = null
var navmesh:Navigation
@export var recipesOption:Array[Enum.RecipeNames]
static var override = [Enum.RecipeNames.TomatoSoup]#= [Enum.RecipeNames.BurSteSal, Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.BurSteSalTom, Enum.RecipeNames.BurSteSalTom, Enum.RecipeNames.CutTomCutSal, Enum.RecipeNames.BurSteSalTom]

var timeLeft = 0
var initialTime = 15

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
	if(override and override.size() > 0):
		recipeWanted = override[0]
		override.remove_at(0)
	else:
		recipeWanted = recipesOption.pick_random()
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
	navmesh.removeObstacle(destinationPoint)


func _ready():
	navmesh = get_tree().get_first_node_in_group("navmesh")
	navmesh.addObstacle(self)
	super._ready()
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	gameManager = get_tree().get_nodes_in_group("GameManager")[0]


func serve(success:bool):
	hierarchy.servePoints.erase(self)
	if(success):
		gameManager.changeScore(Recipes.getScore(recipeWanted))
		client.changeState(1)
		recipeWanted = Enum.RecipeNames.Empty
		await get_tree().create_timer(3.0).timeout
		if storedObject is Plate:
			storedObject.mealFinished()
	else:
		add_to_group("freeServePoint")
		gameManager.changeScore(-Recipes.getScore(recipeWanted))
		recipeWanted = Enum.RecipeNames.Empty
		
	client.changeState(2) 
	client = null
	clientLeft()

func unstore() ->Movable:
	add_to_group("freeServePoint")
	return super.unstore()

func store(i:Movable) -> bool:
	if i is Plate:
		i.served()
	i.parent.objectInHand = null
	i.parent = self
	storedObject = i
	serve(true)
	return true

func _process(_delta):
	if(recipeWanted == Enum.RecipeNames.Empty):
		progressBar.visible = false
		icon.visible = false
	else:
		progressBar.visible = true
		icon.visible = true
		timeLeft -= _delta
		if(timeLeft < 0):
			serve(false)
		else:
			progressBar.value = (timeLeft/initialTime)
			progressBar.visible = true
