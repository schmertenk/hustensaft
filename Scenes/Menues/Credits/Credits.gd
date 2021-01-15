extends Menu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play("up")

func _on_animation_finished(a_name):
	if a_name == "down":
		$AnimationPlayer.play("up")
	else:
		$AnimationPlayer.play("down")
		
