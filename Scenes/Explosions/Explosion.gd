extends Node2D

class_name Explosion

const STATE_WAITING = 0
const STATE_EXPLODING = 1


var state = STATE_WAITING

func explode():
	$AnimationPlayer.play("explode")
	state = STATE_EXPLODING
	
func _process(delta):
	if state == STATE_EXPLODING && !$AnimationPlayer.is_playing():
		queue_free()
