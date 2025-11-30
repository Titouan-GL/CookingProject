extends Node3D

@export var level:int = 0
var progression = 0
@export var displayList:Array[Node3D]
var gameManager:GameManager

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")
	changeDisplayed(0)

func changeDisplayed(i:int, _n:Node3D = null):
	for n in range(displayList.size()):
		displayList[n].visible = false
	if i == 0:
		displayList[0].visible = true
		displayList[1].visible = true
		displayList[2].visible = true
	if i == 1:
		displayList[3].visible = true
	if i == 2:
		displayList[4].visible = true
		displayList[4].reparent(_n)
		displayList[4].position = Vector3(0,0,0)
	if i == 3:
		displayList[5].visible = true
	if i == 5:
		displayList[6].visible = true

func setProgression(p:int, n:Node3D = null):
	if p != progression:
		progression = p
		changeDisplayed(p, n)

func level0():
	if progression == 5:
		if get_tree().get_nodes_in_group("dirtyPlate").size() == 0:
			setProgression(6)
			await get_tree().create_timer(1.5).timeout
			gameManager.endGame()
	if progression < 5:
		for s in get_tree().get_nodes_in_group("servePoint"):
			if s.storedObject is Plate:
				if s.storedObject.dirty:
					setProgression(5)
				else:
					setProgression(4)
	if progression < 4:
		var tomatoCreated = false
		var tomatoCut = false
		var saladCreated = false
		var saladCut = false
		var plate = null
		var mealCreated = false
		for m in get_tree().get_nodes_in_group("movable"):
			if m is Plate:
				plate = m
			if m.recipe == Enum.RecipeNames.CutTomCutSal:
				mealCreated = true
			elif m.recipe == Enum.RecipeNames.Tom:
				tomatoCreated = true
			elif m.recipe == Enum.RecipeNames.CutTom:
				tomatoCreated = true
				tomatoCut = true
			elif m.recipe == Enum.RecipeNames.Sal:
				saladCreated = true
			elif m.recipe == Enum.RecipeNames.CutSal:
				saladCreated = true
				saladCut = true
		if mealCreated:
			setProgression(3)
		elif plate and tomatoCut and saladCut:
			setProgression(2, plate)
		elif plate and tomatoCreated and saladCreated:
			setProgression(1)
		else:
			setProgression(0)
		
func _process(_delta: float) -> void:
	if progression >= 0:
		if level == 0:
			level0()
