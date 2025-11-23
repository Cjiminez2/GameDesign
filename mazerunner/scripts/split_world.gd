extends Node
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
func _setup_maze(scaler: float) -> void:
	maze_grid.scale = Vector2(scaler, scaler)
	second_grid.scale = Vector2(scaler, scaler)
	sprite_one.scale = Vector2(scaler, scaler)
	sprite_two.scale = Vector2(scaler, scaler)
	player_one_collision.scale = Vector2(scaler, scaler)
	player_two_collision.scale = Vector2(scaler, scaler)

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
	_setup_maze(0.5)
	player_one.position = start.position
	player_two.position = start_two.position
	trail_one.clear_points()
	trail_two.clear_points()
	generate_maze()
	
#Maze generation for NORMAL
func _ready() -> void:
	pass

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
	if (one_ready == 0) or (two_ready == 0):
		if Input.is_action_just_pressed("right_1"):
			sprite_one.modulate = Color(1, 0.1, 0.3)
			$Player1/GPUParticles2D.modulate = Color(1, 0.1, 0.3)
			trail_one.modulate = Color(1, 0.1, 0.3)

		if Input.is_action_just_pressed("left_1"):
			sprite_one.modulate = Color(0, 0.4, 1)
			$Player1/GPUParticles2D.modulate = Color(0, 0.4, 1)
			trail_one.modulate = Color(0, 1, 1)

		if Input.is_action_just_pressed("down_1"):
			sprite_one.modulate = Color(0, 1, 0.4)
			$Player1/GPUParticles2D.modulate = Color(0, 1, 0.4)
			trail_one.modulate = Color(0, 1, 0.4)

		if Input.is_action_just_pressed("up_1"):
			sprite_one.modulate = Color(1, 0.5, 0)
			$Player1/GPUParticles2D.modulate = Color(1, 0.5, 0)
			trail_one.modulate = Color(1, 1, 0)

		if Input.is_action_just_pressed("right_2"):
			sprite_two.modulate = Color(1, 0.1, 0.3)
			$Player2/GPUParticles2D.modulate = Color(1, 0.1, 0.3)
			trail_two.modulate = Color(1, 0.1, 0.3)

		if Input.is_action_just_pressed("left_2"):
			sprite_two.modulate = Color(0, 0.4, 1)
			$Player2/GPUParticles2D.modulate = Color(0, 0.4, 1)
			trail_two.modulate = Color(0, 1, 1)

		if Input.is_action_just_pressed("down_2"):
			sprite_two.modulate = Color(0, 1, 0.4)
			$Player2/GPUParticles2D.modulate = Color(0, 1, 0.4)
			trail_two.modulate = Color(0, 1, 0)

		if Input.is_action_just_pressed("up_2"):
			sprite_two.modulate = Color(1, 0.5, 0)
			$Player2/GPUParticles2D.modulate = Color(1, 0.5, 0)
			trail_two.modulate = Color(1, 1, 0)
			
		if Input.is_action_just_pressed("one_ready"):
			one_ready = 1

		if Input.is_action_just_pressed("two_ready"):
			two_ready = 1
			
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
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_goal_2_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
