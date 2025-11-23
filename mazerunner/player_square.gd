extends CharacterBody2D
@export_range(0, 1000) var speed := 60
@export var id: int = 0
func _physics_process(_delta: float) -> void:
	get_player_input()
	move_and_slide()
	
func get_player_input() -> void:
	var vector := Input.get_vector(
		"left_%s" % id, 
		"right_%s" % id, 
		"up_%s" % id, 
		"down_%s" % id
		)
	velocity = vector * speed
