extends CanvasLayer
signal start_normal
signal start_hard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_normal_pressed() -> void:
	$Normal.hide()
	$Hard.hide()
	emit_signal("start_normal")

func _on_hard_pressed() -> void:
	$Normal.hide()
	$Hard.hide()
	emit_signal("start_hard")
