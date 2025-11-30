extends Node3D

@export var level:int = 0
var progression = 0
@export var displayList:Array[Node3D]
var gameManager:GameManager
var objectArray:Array = []
var posOffset = Vector3(0, 1.4, 0)

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")
	if level == 0:
		changeDisplayedLevel0(0)

func changeDisplayedLevel0(i:int):
	for n in range(displayList.size()):
		displayList[n].visible = false
	if i == 0:
		displayList[0].visible = true
	elif i == 1:
		for cutter in get_tree().get_nodes_in_group("IntCUT"):
			if cutter.storedObject == null:
				displayList[1].visible = true
				displayList[1].global_position = cutter.global_position + posOffset
				return
	elif i == 2:
		displayList[2].visible = true
		displayList[2].global_position = objectArray[0].parent.global_position + posOffset
	elif i == 3:
		displayList[3].visible = true
	elif i == 4:
		for cutter in get_tree().get_nodes_in_group("IntCUT"):
			if cutter.storedObject == null:
				displayList[4].visible = true
				displayList[4].global_position = cutter.global_position + posOffset
				return
	elif i == 5:
		displayList[5].visible = true
		displayList[5].global_position = objectArray[1].parent.global_position + posOffset
	elif i == 6:
		displayList[6].visible = true
		if objectArray[2] != null:
			displayList[6].global_position = objectArray[2].parent.global_position + posOffset
	elif i == 7:
		displayList[7].visible = true
		displayList[7].global_position = objectArray[0].parent.global_position + posOffset
		displayList[8].visible = true
		displayList[8].global_position = objectArray[1].parent.global_position + posOffset
	elif i == 8:
		displayList[9].visible = true
	elif i == 10:
		displayList[10].visible = true
	elif i == 11:
		displayList[11].visible = true
	elif i == 12:
		var pot = get_tree().get_first_node_in_group("PotEMPTY")
		displayList[12].visible = true
		displayList[12].global_position = pot.global_position + posOffset
	elif i == 13:
		for c in get_tree().get_nodes_in_group("IntCOOK"):
			if c.storedObject == null or c.storedObject.recipe == Enum.RecipeNames.PotCutTomCutTomCutTom:
				displayList[13].visible = true
				displayList[13].global_position = c.global_position + posOffset
	elif i == 14:
		for p in get_tree().get_nodes_in_group("PotEMPTY"):
			if p.recipe == Enum.RecipeNames.PotTomatoSoup:
				displayList[14].visible = true
				displayList[14].global_position = p.global_position + posOffset
	elif i == 15:
		displayList[9].visible = true

func setProgression(p:int):
	if p != progression:
		progression = p
		if level == 0:
			changeDisplayedLevel0(p)

func level0():
	#0 : unstore tomato
	#1 : bring tomato to cutter
	#2 : cut tomato
	#3 : unstore salad
	#4 : bring salad to cutter
	#5 : cut salad
	#6 : unstore plate
	#7 : mix ingredients
	#8 : bring to client
	#9 : wait for client to finish
	#10: store plate in sink
	#11: clean plate
	#12: store tomatoes in pot
	#13: cook pot
	#14: put soup in plate
	#15: bring to client
	if progression == 15:
		for s in get_tree().get_nodes_in_group("servePoint"):
			if s.storedObject is Plate and s.storedObject.dirty:
				setProgression(16)
				await get_tree().create_timer(4).timeout
				gameManager.endGame()
	elif progression == 14:
		for m in get_tree().get_nodes_in_group("EmptyPlate"):
			if m.recipe == Enum.RecipeNames.TomatoSoup:
				setProgression(15)
	elif progression == 13:
		for p in get_tree().get_nodes_in_group("PotEMPTY"):
			if p.recipe == Enum.RecipeNames.PotTomatoSoup:
				setProgression(14)
	elif progression == 12:
		for p in get_tree().get_nodes_in_group("PotEMPTY"):
			if p.recipe == Enum.RecipeNames.PotCutTomCutTomCutTom:
				setProgression(13)
	elif progression == 11:
		if get_tree().get_nodes_in_group("dirtyPlate").size() == 0:
			setProgression(12)
	elif progression == 10:
		if get_tree().get_first_node_in_group("dirtyPlate").parent is IntSink:
			setProgression(11)
	elif progression <= 9:
		for s in get_tree().get_nodes_in_group("servePoint"):
			if s.storedObject is Plate:
				if s.storedObject.dirty:
					setProgression(10)
				else:
					setProgression(9)
	if progression < 8:
		var tomatoCreated = null
		var tomatoCut = null
		var saladCreated = null
		var saladCut = null
		var plate = null
		var mealCreated = null
		for m in get_tree().get_nodes_in_group("movable"):
			if m is Plate:
				plate = m
			if m.recipe == Enum.RecipeNames.CutTomCutSal:
				mealCreated = m
			elif m.recipe == Enum.RecipeNames.Tom:
				tomatoCreated = m
			elif m.recipe == Enum.RecipeNames.CutTom:
				tomatoCreated = m
				tomatoCut = m
			elif m.recipe == Enum.RecipeNames.Sal:
				saladCreated = m
			elif m.recipe == Enum.RecipeNames.CutSal:
				saladCreated = m
				saladCut = m
		objectArray = [tomatoCreated, saladCreated, plate]
		if mealCreated:
			setProgression(8)
		elif plate and tomatoCut and saladCut:
			setProgression(7)
		elif tomatoCut and saladCut:
			setProgression(6)
		elif tomatoCut and saladCreated:
			if saladCreated.parent is IntCutter:
				setProgression(5)
			else:
				setProgression(4)
		elif tomatoCut:
			setProgression(3)
		elif tomatoCreated:
			if tomatoCreated.parent is IntCutter:
				setProgression(2)
			else:
				setProgression(1)
		else:
			setProgression(0)

func level1():
	if gameManager.clientServed >= 4:
		await get_tree().create_timer(4).timeout
		gameManager.endGame()

func level2():
	if gameManager.clientServed >= 3:
		await get_tree().create_timer(4).timeout
		gameManager.endGame()
		
func level3():
	for s in get_tree().get_nodes_in_group("servePoint"):
		if s.storedObject and s.storedObject.quality >= 3:
			await get_tree().create_timer(2).timeout
			gameManager.endGame()



func _process(_delta: float) -> void:
	if progression >= 0:
		if level == 0:
			level0()
		if level == 1:
			level1()
		if level == 2:
			level2()
		if level == 3:
			level3()
