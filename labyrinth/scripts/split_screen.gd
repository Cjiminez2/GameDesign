extends Node

@onready var transition: AnimationPlayer = $Splitter/ScreenTransition/AnimationPlayer
@onready var view_one: SubViewport = $Splitter/P1Container/P1View
@onready var view_two: SubViewport = $Splitter/P2Container/P2View
@onready var camera_one: Camera2D = $Splitter/P1Container/P1View/P1Camera
@onready var camera_two: Camera2D = $Splitter/P2Container/P2View/P2Camera
@onready var map = $Splitter/P1Container/P1View/World
@onready var winner: Label = $Splitter/ScreenTransition/Results

@onready var player_one_text: Label = $P1Context
@onready var player_two_text: Label = $P2Context
var both_finished: int = 0

func _ready() -> void:
	if (Global.one_wins > Global.two_wins):
		$P1Text.modulate = Color(1, 1, 0)
	elif (Global.two_wins > Global.one_wins):
		$P2Text.modulate = Color(1, 1, 0)
	
	transition.get_parent().get_node("ColorRect").color.a = 255
	transition.play("fade_out")
	view_two.world_2d = view_one.world_2d
	camera_one.target = map.get_node("Player1")
	camera_two.target = map.get_node("Player2")
	
	$P1Text.text = "Player 1 Victories %d" % Global.one_wins
	$P2Text.text = "Player 2 Victories %d" % Global.two_wins
	
func _process(_delta: float) -> void:
	if (both_finished == 2):
		both_finished = 0
		_both_finished()
	
func _both_finished() -> void:
	if (player_one_text.time_elapsed < player_two_text.time_elapsed):
		winner.text = "Player 1 Wins"
		Global.one_wins += 1
	else:
		winner.text = "Player 2 Wins"
		Global.two_wins += 1
	
	transition.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")

func _on_one_wins() -> void:
	player_one_text.stop_timer()
	both_finished += 1
	
	player_two_text.modulate = Color(1, 0, 0)
	await get_tree().create_timer(10.0).timeout
	_both_finished()
	transition.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")


func _on_two_wins() -> void:
	player_two_text.stop_timer()
	both_finished += 1
	
	player_one_text.modulate = Color(1, 0, 0)
	await get_tree().create_timer(10.0).timeout
	_both_finished()
	transition.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")

func _on_one_color_chosen() -> void:
	player_one_text.text = "READY"
	

func _on_two_color_chosen() -> void:
	player_two_text.text = "READY"

func _on_start_timers() -> void:
	player_one_text.position = Vector2i(260, 70)
	player_two_text.position = Vector2i(20, 70)
	player_one_text.start_timer()
	player_two_text.start_timer()


func _on_return_pressed() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(1.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")
