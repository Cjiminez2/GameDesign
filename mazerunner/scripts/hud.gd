extends CanvasLayer
signal start_normal
signal start_hard

func _on_normal_pressed() -> void:
	$Normal.hide()
	$Hard.hide()
	emit_signal("start_normal")

func _on_hard_pressed() -> void:
	$Normal.hide()
	$Hard.hide()
	emit_signal("start_hard")
