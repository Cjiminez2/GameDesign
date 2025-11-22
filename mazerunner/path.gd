extends Line2D

#Leaves a path behind the player
#This tracks where the player has already gone
func _process(_delta: float) -> void:
	var pos = get_parent().position
	add_point(pos)
