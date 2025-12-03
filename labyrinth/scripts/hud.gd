extends CanvasLayer
signal start_normal
signal start_hard
signal back_home

@onready var normal: Button = $Normal
@onready var hard: Button = $Hard
@onready var return_button: Button = $Return

@onready var normal_text: String = "A simple maze to learn the basics."


@onready var hard_text: String = "Double the size, double the fun!"

@onready var return_text: String = "Return to title screen."

func _ready() -> void:
	normal.tooltip_text = normal_text
	hard.tooltip_text = hard_text
	return_button.tooltip_text = return_text

func _on_normal_pressed() -> void:
	normal.hide()
	hard.hide()
	return_button.position = Vector2(0, 371)
	emit_signal("start_normal")

func _on_hard_pressed() -> void:
	normal.hide()
	hard.hide()
	return_button.position = Vector2(0, 371)
	emit_signal("start_hard")

func _on_returned() -> void:
	emit_signal("back_home")
