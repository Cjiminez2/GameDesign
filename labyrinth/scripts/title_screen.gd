extends Control
@onready var transition: AnimationPlayer = $ScreenTransition/AnimationPlayer

@onready var escape: TextureButton = $Escape
@onready var race: TextureButton = $Race
@onready var home: TextureButton = $GoHome
@onready var color: TextureButton = $ColorSquare

var escape_text: String = "Find a way outside of the labyrinth"
var race_text: String = "Escape with a friend! Who's faster?"
var home_text: String = "Bye bye"
var color_text: String = "$#!+! you found me!"

var color_index: int = 0
var colors := [
	Color(0, 0.4, 1),
	Color(0, 1, 0.4),
	Color(1, 0.5, 0),
	Color(1, 0, 0)
]


func _ready() -> void:
	color.modulate = Global.current_color
	transition.get_parent().get_node("ColorRect").color.a = 255
	transition.play("fade_out")
	escape.tooltip_text = escape_text
	race.tooltip_text = race_text
	home.tooltip_text = home_text
	color.tooltip_text = color_text

func _on_escape_pressed() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	Global.goto_scene("res://scenes/map.tscn")

func _on_race_pressed() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	Global.goto_scene("res://scenes/split_screen.tscn")


func _on_go_home_pressed() -> void:
	get_tree().quit()


func _on_color_square_pressed() -> void:
	color.modulate = colors[color_index]
	Global.current_color = colors[color_index]
	color_index = ((color_index + 1) % 4)
