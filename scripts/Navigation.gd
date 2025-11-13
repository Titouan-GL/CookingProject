extends Node3D

class_name Navigation

@export var gridMax:Vector2i
@export var gridMin:Vector2i
var gridSize:Vector2i
var grid:Array
var astarCooks = AStarGrid2D.new()
var astarClient = AStarGrid2D.new()
var agentRadius = 0.4


# # # # # # # # # # 
# . . . . . . . . # 
# . . . . . . . . # 
# . . . . # . . . # 
# . . . . # . # . # 
# . . . . # . . . # 
# . . . . # . . . # 
# . . . . . . . . # 
# . . . . . . . . # 
# # # # # # # # # # 

func addObstacle(node, onlyCooks = false):
	var pos = nodeToGrid(node)
	grid[pos.y][pos.x] = node 
	if(astarCooks.region):
		astarCooks.set_point_solid(pos, true)
		if(not onlyCooks): astarClient.set_point_solid(pos, true)

func removeObstacle(node):
	var pos = nodeToGrid(node)
	grid[pos.y][pos.x] = null 
	if(astarCooks.region):
		astarCooks.set_point_solid(pos, false)
		astarClient.set_point_solid(pos, false)


func _enter_tree():
	add_to_group("navmesh")
	gridSize.x = gridMax.x - gridMin.x +1
	gridSize.y = gridMax.y - gridMin.y +1
	for i in range(gridSize.y):
		grid.append([])
		for j in range(gridSize.x):
			grid[i].append(null)
	
	for astar in [astarClient, astarCooks] :
		astar.region = Rect2i(Vector2i(0, 0), Vector2i(gridSize.x, gridSize.y))
		astar.cell_size = Vector2i(1, 1)
		astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar.update()

func nodeToGrid(node:Node3D):
	return posToGrid(node.global_position)

func posToGrid(v:Vector3):
	return Vector2i(int(roundf(v.x)), int(roundf(v.z)))-gridMin

func xyzTOxz(v1:Vector3):
	return Vector2(v1.x, v1.z)
	
func gridToPos(gridPos:Vector2i, nodePos:Vector3) -> Vector3:
	return Vector3(gridPos.x + gridMin.x, nodePos.y, gridPos.y + gridMin.y)

func bresenham_float(start: Vector2, end: Vector2) -> Array: #made using chatGPT
	var points: Array = []
	var x0 = start.x
	var y0 = start.y
	var x1 = end.x
	var y1 = end.y
	var dx = x1 - x0
	var dy = y1 - y0
	var step_x = 1 if dx > 0 else -1
	var step_y = 1 if dy > 0 else -1
	# Distance in each axis to next grid line
	var t_max_x = 0.0
	var t_max_y = 0.0
	var t_delta_x = 0.0
	var t_delta_y = 0.0
	# Current grid cell
	var cell_x = int(roundf(x0))
	var cell_y = int(roundf(y0))
	points.append(Vector2i(cell_x, cell_y))
	# Prevent division by zero
	if dx != 0.0:
		var next_x = cell_x + (0.5 if dx > 0 else -0.5)
		t_max_x = abs((next_x - x0) / dx)
		t_delta_x = abs(1.0 / dx)
	else:
		t_max_x = INF
		t_delta_x = INF
	if dy != 0.0:
		var next_y = cell_y + (0.5 if dy > 0 else -0.5)
		t_max_y = abs((next_y - y0) / dy)
		t_delta_y = abs(1.0 / dy)
	else:
		t_max_y = INF
		t_delta_y = INF
	# Traverse cells until reaching the one containing the end point
	var end_cell_x = int(roundf(x1))
	var end_cell_y = int(roundf(y1))
	
	var safe = 1000
	while not (cell_x == end_cell_x and cell_y == end_cell_y):
		safe -= 1
		if t_max_x < t_max_y:
			cell_x += step_x
			t_max_x += t_delta_x
		else:
			cell_y += step_y
			t_max_y += t_delta_y
		points.append(Vector2i(cell_x, cell_y))
		if(safe <= 0):
			print("error")
			return []
	return points
	
	
func line_is_clear(astar:AStarGrid2D, start: Vector2, end: Vector2) -> bool:
	var translated_vector = Vector2(start.x - gridMin.x, start.y-gridMin.y)
	var direction_vector = (translated_vector-end).normalized()
	var orthogonal_vector = Vector2(direction_vector.y, -direction_vector.x) * agentRadius
	var line_points = []
	line_points += bresenham_float(translated_vector + orthogonal_vector, end + orthogonal_vector)
	line_points += bresenham_float(translated_vector - orthogonal_vector, end - orthogonal_vector)
	for p in line_points:
		if p.y < 0 or p.y >= grid.size() or p.x < 0 or p.x >= grid[0].size():
			return false
		if astar.is_point_solid(p):
			return false
	return true
	
func getNextPosition(startNode, endNode, isClient = false):
	if(not startNode or not endNode):
		return
	var startPos3D
	if startNode is Node3D : startPos3D = startNode.global_position
	if startNode is Vector3 : startPos3D = startNode
	var endPos3D
	if endNode is Node3D : endPos3D = endNode.global_position
	if endNode is Vector3 : endPos3D = endNode
	var startPos2D = posToGrid(startPos3D)
	var astarUsed = astarClient if isClient else astarCooks
	var endPos2D = find_reachable(astarUsed, posToGrid(endPos3D))
	if(endPos2D):
		endPos3D = gridToPos(endPos2D, endPos3D)
		var path = astarUsed.get_point_path(startPos2D, endPos2D)
		if(path.size() > 1):
			var i:int = 0
			while i+1 < path.size() and line_is_clear(astarUsed, xyzTOxz(startPos3D), path[i+1]) and i < 10:
				i += 1
			return gridToPos(path[i], startPos3D)
		elif xyzTOxz(startPos3D - endPos3D).length() > 0.1:
			return Vector3(endPos3D.x, startPos3D.y, endPos3D.z)
	else:
		return null

func get_full_path(startNode, endNode, isClient = false):
	if(not startNode or not endNode):
		return
	var startPos3D
	if startNode is Node3D : startPos3D = startNode.global_position
	if startNode is Vector3 : startPos3D = startNode
	var endPos3D
	if endNode is Node3D : endPos3D = endNode.global_position
	if endNode is Vector3 : endPos3D = endNode
	var startPos2D = posToGrid(startPos3D)
	var astarUsed = astarClient if isClient else astarCooks
	var endPos2D = find_reachable(astarUsed, posToGrid(endPos3D))
	if(endPos2D):
		return astarUsed.get_point_path(startPos2D, endPos2D)
	else:
		return null
	

func find_reachable(astar:AStarGrid2D, current:Vector2i):
	if(not astar.is_point_solid(current)):
		return current
	for x in range(-1, 2, 2):
		if current.x+x >= 0 and current.x <= gridSize.x+x and not astar.is_point_solid(current + Vector2i(x, 0)):
			return current+Vector2i(x, 0)
	for y in range(-1, 2, 2):
		if current.y+y >= 0 and current.y <= gridSize.y+y and not astar.is_point_solid(current + Vector2i(0, y)):
			return current+Vector2i(0, y)
	
	for x in range(-1, 2, 2):
		for y in range(-1, 2, 2):
			if current.y+y >= 0 and current.y <= gridSize.y+y and \
			current.x+x >= 0 and current.x <= gridSize.x+x and\
			not astar.is_point_solid(current + Vector2i(x, y)):
				return current+Vector2i(x, y)

#func find_reachable(astar:AStarGrid2D, current:Vector2, origin:Vector2):
	#if(not astar.is_point_solid(current)):
		#return current
	#
	#var closest = current + Vector2(-1, 0)
	#for x in range(-1, 1, 2):
		#for y in range(-1, 1, 2):
			#if current.y+y >= 0 and current.y <= gridSize.y+y and \
			#current.x+x >= 0 and current.x <= gridSize.x+x and\
			#not astar.is_point_solid(current + Vector2(x, y)):
				#if (closest-origin).length() <  (origin-(current+Vector2(x, y))).length():
					#closest = current+Vector2(x, y)
	#if not astar.is_point_solid(closest):
		#return closest

func printGrid():
	for y in gridSize.y:
		var row = ""
		for x in gridSize.x:
			if grid[y][x] == null:
				row += ". "
			else:
				row += "# "
		print(row)

func print_astar_grid(isClient = false):
	var astarUsed = astarClient if isClient else astarCooks
	var region = astarUsed.region
	for y in range(region.position.y, region.position.y + region.size.y):
		var row = ""
		for x in range(region.position.x, region.position.x + region.size.x):
			var pos = Vector2i(x, y)
			if astarUsed.is_point_solid(pos):
				row += "# "   # obstacle
			else:
				row += ". "   # walkable
		print(row)
