extends Node
#Common variables
@onready var transition: AnimationPlayer = $HUD/ScreenTransition/AnimationPlayer
@onready var maze_grid: TileMapLayer = $MazeGrid
@onready var player: CharacterBody2D = $PlayerSquare
@onready var goal: CollisionShape2D = $Goal/CollisionShape2D

var ROWS: int
var COLS: int
const WALL: Vector2i = Vector2i(0, 0)
const PATH: Vector2i = Vector2i(1, 0)

var maze := []

#Scales the maze according to the difficulty
func _setup_maze(scale: float) -> void:
	var scaler: float = 1 / scale
	player.visible = !player.visible
	player.change_color(Color(1, 0, 0))
	maze_grid.scale = Vector2(scaler, scaler)
	player.scale_player(scaler)
	goal.position = maze_grid.to_global(maze_grid.map_to_local(Vector2i(COLS - 2, ROWS + 1)))
	player.position = maze_grid.to_global(maze_grid.map_to_local(Vector2i(1,1)))
	player.clear_trail()

	
#Maze generation for NORMAL
func _new_normal() -> void:
	ROWS = 25
	COLS = 25
	_setup_maze(1.0)
	generate_maze()

#Maze generation for HARD
func _new_hard() -> void:
	ROWS = 55
	COLS = 55
	_setup_maze(2.0)
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
	transition.play("fade_in")
	await get_tree().create_timer(1.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")
	
func _ready() -> void:
	transition.get_parent().get_node("ColorRect").color.a = 255
	transition.play("fade_out")
