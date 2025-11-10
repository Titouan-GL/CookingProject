extends Node3D

class_name Navigation

@export var gridX:Vector2i
@export var gridY:Vector2i
var gridSize:Vector2i
var grid:Array
var astar = AStarGrid2D.new()

func addObstacle(node):
	var pos = nodeToGrid(node)
	grid[pos.y][pos.x] = node 

func _enter_tree():
	add_to_group("navmesh")
	gridSize.x = gridX.y - gridX.x +1
	gridSize.y = gridY.y - gridY.x +1
	for i in range(gridSize.y):
		grid.append([])
		for j in range(gridSize.x):
			grid[i].append(null)

func nodeToGrid(node:Node3D):
	return posToGrid(node.global_position)

func posToGrid(v:Vector3):
	return Vector2i(int(roundf(v.x))-gridX.x, int(roundf(v.z))-gridY.x)

func xyzTOxz(v1:Vector3):
	return Vector2(v1.x, v1.z)

func gridToPos(gridPos:Vector2i, nodePos:Vector3) -> Vector3:
	return Vector3(gridPos.x + gridX.x, nodePos.y, gridPos.y + gridY.x)

func bresenham_line(start: Vector2i, end: Vector2i) -> Array:
	var points: Array = []
	var x0 = start.x
	var y0 = start.y
	var x1 = end.x
	var y1 = end.y
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy
	while true:
		points.append(Vector2i(x0, y0))
		if x0 == x1 and y0 == y1:
			break
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
	return points
	
	
func line_is_clear(start: Vector2i, end: Vector2i) -> bool:
	var line_points = bresenham_line(start, end)
	for p in line_points:
		if p.y < 0 or p.y >= grid.size() or p.x < 0 or p.x >= grid[0].size():
			return false
		if astar.is_point_solid(p):
			return false
	return true
	
func getNextPosition(startNode, endNode):
	if(not startNode or not endNode):
		return
	var startPos3D
	if startNode is Node3D : startPos3D = startNode.global_position
	if startNode is Vector3 : startPos3D = startNode
	var endPos3D
	if endNode is Node3D : endPos3D = endNode.global_position
	if endNode is Vector3 : endPos3D = endNode
	var startPos2D = posToGrid(startPos3D)
	var endPos2D = find_reachable(posToGrid(endPos3D))
	if(endPos2D):
		var path = astar.get_point_path(startPos2D, endPos2D)
		print(line_is_clear(startPos2D, path[1]))
		if(path.size() > 1):
			return gridToPos(path[1], startPos3D)
		elif xyzTOxz(startPos3D - endPos3D).length() > 0.1:
			return Vector3(endPos3D.x, startPos3D.y, endPos3D.z)


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

func find_reachable(current:Vector2i):
	print(astar.is_point_solid(current), " " , current)
	if(not astar.is_point_solid(current)):
		return current
	for x in range(-1, 2, 2):
		if current.x+x >= 0 and current.x <= gridSize.x+x and not astar.is_point_solid(current + Vector2i(x, 0)):
			return current+Vector2i(x, 0)
	for y in range(-1, 2, 2):
		if current.y+y >= 0 and current.y <= gridSize.y+y and not astar.is_point_solid(current + Vector2i(0, y)):
			return current+Vector2i(0, y)
		

func _ready():
	astar.region = Rect2i(Vector2i(0, 0), Vector2i(gridSize.x, gridSize.y))
	astar.cell_size = Vector2i(1, 1)
	astar.update()
	for y in range(gridSize.y):
		for x in range(gridSize.x):
			if grid[y][x] != null:
				astar.set_point_solid(Vector2i(x, y), true)
	printGrid()

func printGrid():
	for y in gridSize.y:
		var row = ""
		for x in gridSize.x:
			if grid[y][x] == null:
				row += ". "
			else:
				row += "# "
		print(row)

func print_astar_grid():
	var region = astar.region
	for y in range(region.position.y, region.position.y + region.size.y):
		var row = ""
		for x in range(region.position.x, region.position.x + region.size.x):
			var pos = Vector2i(x, y)
			if astar.is_point_solid(pos):
				row += "# "   # obstacle
			else:
				row += ". "   # walkable
		print(row)
