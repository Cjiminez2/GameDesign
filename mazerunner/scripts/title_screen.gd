extends Control

func _on_1player_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_2player_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/split_screen.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
