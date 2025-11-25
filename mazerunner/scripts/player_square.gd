extends CharacterBody2D
signal ready_1
signal ready_2

@export_range(0, 1000) var speed := 60
@export var id: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var trail: Line2D = $Path
@onready var collision: CollisionShape2D = $CollisionShape2D

var player_ready: int = -1

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
	
func scale_player(scaler: float) -> void:
	sprite.scale = Vector2(scaler, scaler)
	collision.scale = Vector2(scaler, scaler)

func change_color(color: Color) -> void:
	sprite.modulate = color
	particles.modulate = color
	trail.modulate = color

func choose_color() -> void:
	if (player_ready == -1):
		if Input.is_action_just_pressed("right_%s" % id):
			change_color(Color(1, 0.1, 0.3))

		if Input.is_action_just_pressed("left_%s" % id):
			change_color(Color(0, 0.4, 1))

		if Input.is_action_just_pressed("down_%s" % id):
			change_color(Color(0, 1, 0.4))

		if Input.is_action_just_pressed("up_%s" % id):
			change_color(Color(1, 0.5, 0))
			
		if Input.is_action_just_pressed("white_%s" % id):
			change_color(Color(1, 1, 1))

		if Input.is_action_just_pressed("ready_%s" % id):
			player_ready = 1
			emit_signal("ready_%s" % id)

func clear_trail() -> void:
	trail.clear_points()
