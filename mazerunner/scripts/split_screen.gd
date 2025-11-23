extends Node

@onready var view_one: SubViewport = $Splitter/P1Container/P1View
@onready var view_two: SubViewport = $Splitter/P2Container/P2View
@onready var camera_one: Camera2D = $Splitter/P1Container/P1View/P1Camera
@onready var camera_two: Camera2D = $Splitter/P2Container/P2View/P2Camera
@onready var map = $Splitter/P1Container/P1View/World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	view_two.world_2d = view_one.world_2d
	camera_one.target = map.get_node("Player1")
	camera_two.target = map.get_node("Player2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
