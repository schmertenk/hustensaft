extends Node2D

class_name Explosion

const STATE_WAITING = 0
const STATE_EXPLODING = 1

export (float) var duration = 3
export (String) var sound_name
export (float) var screenshake_amp = 0
var state = STATE_WAITING

func explode():
	state = STATE_EXPLODING
	$Tween.interpolate_property($Light2D, "energy", 1, 0, duration / 6)
	$Tween.interpolate_callback(self, duration, "queue_free")
	$Particles2D.emitting = true
	$Tween.start()
	AudioManager.play(sound_name, true)
	if screenshake_amp:
		get_node("/root/Game/Camera").shake(0.2, 20.0, screenshake_amp)
