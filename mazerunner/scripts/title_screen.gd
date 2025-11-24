extends Control
@onready var transition: AnimationPlayer = $ScreenTransition/AnimationPlayer

func _ready() -> void:
	transition.get_parent().get_node("ColorRect").color.a = 255
	transition.play("fade_out")

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
