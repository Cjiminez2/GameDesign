extends Control

func _on_normal_pressed() -> void:
	get_tree().change_scene_to_file("res://map.tscn")

func _on_hard_pressed() -> void:
	get_tree().change_scene_to_file("res://map.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
