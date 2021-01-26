extends AudioStreamPlayer

class_name MyAudioStreamPlayer

signal sound_finished

var sound_name = ""
var sound_type = ""
var volume_mod = 1


func _ready():
	connect("finished", self, "_on_self_finished")
	
func stop():
	.stop()
	emit_signal("sound_finished", self)

func _on_self_finished():
	emit_signal("sound_finished", self)
