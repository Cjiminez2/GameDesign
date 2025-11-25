extends Node

signal one_wins
signal two_wins
#Common variables
@onready var maze_grid: TileMapLayer = $MazeGrid
@onready var second_grid: TileMapLayer = $MazeGrid2
@onready var start: Marker2D = $StartPosition
@onready var start_two: Marker2D = $StartPosition2
@onready var goal: CollisionShape2D = $Goal/CollisionShape2D
@onready var goal_two: CollisionShape2D = $Goal2/CollisionShape2D

@onready var player_one: CharacterBody2D = $Player1
@onready var sprite_one: Sprite2D = $Player1/Sprite2D
@onready var player_one_collision: CollisionShape2D = $Player1/CollisionShape2D
@onready var trail_one: Line2D = $Player1/Path

@onready var player_two: CharacterBody2D = $Player2
@onready var sprite_two: Sprite2D = $Player2/Sprite2D
@onready var player_two_collision: CollisionShape2D = $Player2/CollisionShape2D
@onready var trail_two: Line2D = $Player2/Path

var both_ready: int = 0
var one_ready: int = 0
var two_ready: int = 0

var ROWS: int = 55
var COLS: int = 55
const WALL: Vector2i = Vector2i(0, 0)
const PATH: Vector2i = Vector2i(1, 0)

var maze := []

#Scales the maze according to the difficulty
func _setup_maze(scale: float) -> void:
	var scaler: float = 1 / scale
	maze_grid.scale = Vector2(scaler, scaler)
	second_grid.scale = Vector2(scaler, scaler)
	player_one.scale_player(scaler)
	player_two.scale_player(scaler)
	goal.position = maze_grid.to_global(maze_grid.map_to_local(Vector2i(COLS - 2, ROWS + 1)))
	player_one.position = maze_grid.to_global(maze_grid.map_to_local(Vector2i(1,1)))
	
	goal_two.position = second_grid.to_global(second_grid.map_to_local(Vector2i(COLS - 2, ROWS + 1)))
	player_two.position = second_grid.to_global(second_grid.map_to_local(Vector2i(1,1)))

#Base settup for the setup to scale from
func _base_maze() -> void:
	sprite_one.texture.width = 12
	sprite_one.texture.height = 12
	player_one_collision.shape.set_size(Vector2(12, 12))
	
	sprite_two.texture.width = 12
	sprite_two.texture.height = 12
	player_two_collision.shape.set_size(Vector2(12, 12))

func race_start() -> void:
	_base_maze()
	_setup_maze(2.0)
	player_one.position = start.position
	player_two.position = start_two.position
	trail_one.clear_points()
	trail_two.clear_points()
	generate_maze()
	
	
func _ready() -> void:
	player_one.change_color(Color(1, 0, 0))
	player_two.change_color(Color(1, 0, 0))

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
			second_grid.set_cell(Vector2i(c, r), 0, tile_type)

func _choose_color() -> void:
	player_one.choose_color()
	player_two.choose_color()
			
	both_ready = one_ready + two_ready
		
	if (both_ready == 2):
		both_ready = -1
		one_ready = -1
		two_ready = -1
		race_start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_choose_color()

func _on_goal_body_entered(_body: Node2D) -> void:
	emit_signal("one_wins")


func _on_goal_2_body_entered(_body: Node2D) -> void:
	emit_signal("two_wins")


func _on_ready_1() -> void:
	one_ready = 1

func _on_ready_2() -> void:
	two_ready = 1
