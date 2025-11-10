extends Interactible
class_name IntServe

var hierarchy:Hierarchy
var recipeWanted:Enum.RecipeNames
@export var icon:IngredientIcon
@export var progressBar:ProgressBar

var timeLeft = 0
var initialTime = 15

func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true

func newRecipe():
	recipeWanted = [Enum.RecipeNames.TomatoSoup, Enum.RecipeNames.Burger].pick_random()
	icon.UpdateAppearance(recipeWanted)

func _ready():
	super._ready()
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	hierarchy.servePoints.append(self)
	newRecipe()

func serve():
	newRecipe()
	hierarchy.servePoints.erase(self)
	hierarchy.servePoints.append(self)
	timeLeft = initialTime

func store(i:Movable) -> bool:
	if(i is MovableCooker):
		i.empty()
		serve()
		return true
	elif(i is Ingredient):
		i.parent.objectInHand = null
		i.queue_free()
		serve()
		return true
	return false

func _process(_delta):
	timeLeft -= _delta
	if(timeLeft < 0):
		serve()
	else:
		progressBar.value = (timeLeft/initialTime)
		progressBar.visible = true
