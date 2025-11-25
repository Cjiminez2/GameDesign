extends Node

@onready var transition: AnimationPlayer = $Splitter/ScreenTransition/AnimationPlayer
@onready var view_one: SubViewport = $Splitter/P1Container/P1View
@onready var view_two: SubViewport = $Splitter/P2Container/P2View
@onready var camera_one: Camera2D = $Splitter/P1Container/P1View/P1Camera
@onready var camera_two: Camera2D = $Splitter/P2Container/P2View/P2Camera
@onready var map = $Splitter/P1Container/P1View/World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.get_parent().get_node("ColorRect").color.a = 255
	transition.play("fade_out")
	view_two.world_2d = view_one.world_2d
	camera_one.target = map.get_node("Player1")
	camera_two.target = map.get_node("Player2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_one_wins() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(1.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")


func _on_two_wins() -> void:
	#$Splitter/ScreenTransition/TextEdit.visible = !$Splitter/ScreenTransition/TextEdit.visible
	transition.play("fade_in")
	await get_tree().create_timer(1.0).timeout
	Global.goto_scene("res://scenes/title_screen.tscn")
