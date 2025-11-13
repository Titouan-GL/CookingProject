extends RigidBody3D
class_name Movable

var parent:Node3D
var occupied:bool = false
var canBeOccupied:bool = true
var task:Task = null
var progress:Dictionary
var prevProgress:Dictionary
var progressMaxValues:Dictionary
@export var recipe:Enum.RecipeNames = Enum.RecipeNames.Empty
var visibleMesh:Node3D = null
@export var progressBar:ProgressBar

func UpdateAppearance():
	var newMesh = Recipes.recipeToMesh(recipe)
	if(visibleMesh) : visibleMesh.queue_free()
	if(newMesh):
		visibleMesh = newMesh.instantiate()
		add_child(visibleMesh)
		visibleMesh.set_position(Vector3.ZERO)
		
func pickUp(p:Node3D):
	if(parent is Interactible):
		parent.unStore()
	if(parent is Agent):
		parent.objectInHand = null
	parent = p
	
func assignedToTask(_task:Task):
	occupied = true
	task = _task
	
func dropped():
	parent = null

func _process(_delta):
	UpdateAppearance()
	if(progressBar): 
		if(progress != prevProgress):
			progressBar.visible = true
			prevProgress = progress.duplicate()
		else:
			progressBar.visible = false
	if parent:
		global_position = Vector3(parent.storePoint.global_position)
		global_rotation = Vector3(parent.storePoint.global_rotation)

func _enter_tree():
	add_to_group("movable")

func _ready():
	prevProgress = progress.duplicate()
