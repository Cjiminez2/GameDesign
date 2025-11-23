extends Node
#Common variables
@onready var maze_grid: TileMapLayer = $MazeGrid
@onready var player: CharacterBody2D = $PlayerSquare
@onready var sprite: Sprite2D = $PlayerSquare/Sprite2D
@onready var player_collision: CollisionShape2D = $PlayerSquare/CollisionShape2D
@onready var trail: Line2D = $PlayerSquare/Path
@onready var start: Marker2D = $StartPosition
@onready var goal: CollisionShape2D = $Goal/CollisionShape2D

var ROWS: int
var COLS: int
const WALL: Vector2i = Vector2i(0, 0)
const PATH: Vector2i = Vector2i(1, 0)

var maze := []

#Scales the maze according to the difficulty
func _setup_maze(scaler: float) -> void:
	maze_grid.scale = Vector2(scaler, scaler)
	start.scale = Vector2(scaler, scaler)
	sprite.scale = Vector2(scaler, scaler)
	player_collision.scale = Vector2(scaler, scaler)

#Base settup for the setup to scale from
func _base_maze() -> void:
	start.position = Vector2(17, 17)
	sprite.texture.width = 12
	sprite.texture.height = 12
	player_collision.shape.set_size(Vector2(12, 12))
	
#Maze generation for NORMAL
func _new_normal() -> void:
	maze_grid.collision_enabled = false
	_base_maze()
	_setup_maze(1.0)
	goal.position = Vector2(375, 420)
	player.position = start.position
	trail.clear_points()
	ROWS = 25
	COLS = 25
	generate_maze()

#Maze generation for HARD
func _new_hard() -> void:
	_base_maze()
	_setup_maze(0.5)
	goal.position = Vector2(425, 455)
	player.position = start.position
	player.position.x -= 5
	trail.clear_points()
	ROWS = 55
	COLS = 55
	generate_maze()
	
func reset_maze() -> void:
	maze = []
	for r in range(ROWS):
		var row = []
		for c in range(COLS):
			row.append(1)
		maze.append(row)

func generate_maze() -> void:
	reset_maze()
	
	var start_row: int = 1
	var start_col: int = 1
	maze[start_row][start_col] = 0
	
	carve_passage(start_row, start_col)
	#Adds the EXIT
	maze[-1][-2] = 0
	draw_maze()
	
func carve_passage(row, col) -> void:
	var directions = [
		[-2, 0], #Up
		[0, 2], #Right
		[2, 0], #Down
		[0, -2] #Left
	]
	#Randomize maze paths
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

func draw_maze() -> void:
	maze_grid.clear()
	
	for r in range(ROWS):
		for c in range(COLS):
			var tile_type = WALL if maze[r][c] == 1 else PATH
			maze_grid.set_cell(Vector2i(c, r), 0, tile_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_goal_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
