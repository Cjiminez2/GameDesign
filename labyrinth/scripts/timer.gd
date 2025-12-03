extends Label

var time_elapsed: float = 0.0
var is_running: bool = false

func format_time(time: float) -> void:
	var seconds: int = int(time) % 60
	var minutes: int = int(time / 60) % 60
	var milliseconds: int = int(time * 1000) % 1000
	text = "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
	
func start_timer() -> void:
	is_running = true
	
func stop_timer() -> void:
	is_running = false

func _process(delta: float) -> void:
	if is_running:
		time_elapsed += delta
		format_time(time_elapsed)
