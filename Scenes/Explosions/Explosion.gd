extends Node2D

class_name Explosion

const STATE_WAITING = 0
const STATE_EXPLODING = 1

export (float) var duration = 3
var state = STATE_WAITING

func explode():
	state = STATE_EXPLODING
	$Tween.interpolate_property($Light2D, "energy", 1, 0, duration / 6)
	$Tween.interpolate_callback(self, duration, "queue_free")
	$Particles2D.emitting = true
	$Tween.start()
