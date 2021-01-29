extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.init()
	$AnimationPlayer.play("show")
	

func next():
	$TransitionMask.slide_in(Global, "go_to_menu", 0)
