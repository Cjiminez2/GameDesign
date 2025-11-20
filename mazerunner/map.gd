extends Node

@onready var tilemaplayer = $TileMapLayer
const ROWS = 25
const COLS = 25
const WALL = Vector2i(0, 0)
const PATH = Vector2i(1, 0)

var maze = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_maze()

func reset_maze():
	maze = []
	for r in range(ROWS):
		var row = []
		for c in range(COLS):
			row.append(1)
		maze.append(row)

func generate_maze():
	reset_maze()
	
	var start_row = 1
	var start_col = 1
	maze[start_row][start_col] = 0
	
	carve_passage(start_row, start_col)
	#Adds the EXIT
	maze[24][23] = 0
	draw_maze()
	
func carve_passage(row, col):
	var directions = [
		[-2, 0], #Up
		[0, 2], #Right
		[2, 0], #Down
		[0, -2] #Left
	]
	
	directions.shuffle()
	
	for dir in directions:
		var dr = dir[0]
		var dc = dir[1]
		
		var new_row = row + dr
		var new_col = col + dc
		
		if (
			new_row > 0 and 
			new_col > 0 and 
			new_row < ROWS - 1 and 
			new_col < COLS - 1 and 
			maze[new_row][new_col] == 1
		):
			maze[new_row][new_col] = 0
			maze[row + dr / 2][col + dc / 2] = 0
			
			carve_passage(new_row, new_col)

func draw_maze():
	tilemaplayer.clear()
	
	for r in range(ROWS):
		for c in range(COLS):
			var tile_type = WALL if maze[r][c] == 1 else PATH
			tilemaplayer.set_cell(Vector2i(c, r), 0, tile_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_goal_body_entered(_body: Node2D) -> void:
	$PlayerSquare.position = $StartPosition.position
	$PlayerSquare/Line2D.clear_points()
	generate_maze()
