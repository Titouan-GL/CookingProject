extends Hoverable
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
@export var progressBar:MovableUI
var parentOffset:Vector3
var rb:RigidBody3D
var inUse:bool = false
@export var recipePlacement:Node3D
@export var upgradeParticles:GPUParticles3D
var quality = 0

func increaseQuality(proba:float):
	if randf() < proba :
		if quality < 3:
			upgradeParticles.emitting = true
			quality += 1
			updateStar()


func UpdateAppearance():
	updateStar()
	progressBar.updateStarLevel(quality)
	var newMesh = Recipes.recipeToMesh(recipe)
	if(visibleMesh) : 
		visibleMesh.queue_free()
	if(newMesh):
		visibleMesh = newMesh.instantiate()
		if recipePlacement:
			recipePlacement.add_child(visibleMesh)
		else:
			add_child(visibleMesh)
		visibleMesh.set_position(Vector3.ZERO)
		findMeshInstances(visibleMesh)
		if ishovered : 
			unhovered()
			hovered()
		
func pickUp(p:Node3D):
	rb.set_collision_layer_value(3, false)
	rb.sleeping = true
	rb.freeze = true
	if(parent is Interactible):
		parent.unstore()
	if(parent is Cook):
		parent.objectInHand = null
	parent = p
	
func assignedToTask(_task:Task):
	occupied = true
	task = _task
	
func dropped():
	parent = null
	rb.sleeping = false
	rb.freeze = false
	rb.set_collision_layer_value(3, true)

func _physics_process(_delta: float):
	if parent:
		global_position = Vector3(parent.storePoint.global_position + parentOffset)
		global_rotation = Vector3(parent.storePoint.global_rotation + parentOffset)
	if global_position.y < -10:
		global_position = get_tree().get_first_node_in_group("player").global_position

func _process(_delta):
	if(progressBar): 
		if(progress != prevProgress):
			inUse = true
			progressBar.setVisibility(true)
			prevProgress = progress.duplicate()
		else:
			inUse = false
			progressBar.setVisibility(false)


func _enter_tree():
	rb = $"."
	add_to_group("movable")
	super._enter_tree()

func updateStar():
	progressBar.updateStarLevel(quality)

func _ready():
	prevProgress = progress.duplicate()
	UpdateAppearance()
