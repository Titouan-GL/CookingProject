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

var timeLeft = 0
var initialTime = 30

func _enter_tree():
	super._enter_tree()
	if(available) : 
		add_to_group("freeServePoint")
	destinationPoint.visible = available

func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true
	obstacle = false

func newRecipe():
	recipeWanted = [Enum.RecipeNames.BurSteSalTom, Enum.RecipeNames.BurSteSal, Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.CutTomCutSal].pick_random()
	#recipeWanted = Enum.RecipeNames.BurSteSalTom
	timeLeft = initialTime
	icon.UpdateAppearance(recipeWanted)

func reserved(c:Client):
	remove_from_group("freeServePoint")
	client = c

func clientSat():
	navmesh.addObstacle(destinationPoint, true)

func clientLeft():
	navmesh.removeObstacle(destinationPoint)


func _ready():
	navmesh = get_tree().get_first_node_in_group("navmesh")
	navmesh.addObstacle(self)
	super._ready()
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	gameManager = get_tree().get_nodes_in_group("GameManager")[0]
	
	hierarchy.servePoints.append(self)

func serve(success:bool):
	recipeWanted = Enum.RecipeNames.Empty
	client.changeState(1) 
	await get_tree().create_timer(3.0).timeout
	add_to_group("freeServePoint")
	hierarchy.servePoints.erase(self)
	hierarchy.servePoints.append(self)
	if(success):
		gameManager.changeScore(200)
	else:
		gameManager.changeScore(-200)
	client.changeState(2) 
	client = null
	clientLeft()
	

func store(i:Movable) -> bool:
	if(i is MovableCooker):
		i.empty()
		serve(true)
		return true
	elif(i is Ingredient):
		i.parent.objectInHand = null
		i.queue_free()
		serve(true)
		return true
	return false

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
