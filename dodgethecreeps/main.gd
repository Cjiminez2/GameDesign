extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")


func _on_mob_timer_timeout() -> void:
	#Create new instance
	var mob = mob_scene.instantiate()
	
	#Choose random location from path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	#Set mob position to random path position
	mob.position = mob_spawn_location.position
	
	#Set mob direction perpendicular to path
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Add a little randomness to path
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Choose speed
	var velocity = Vector2(randf_range(200, 750), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Spawn a child
	add_child(mob)
	mob.add_to_group("mobs")


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
