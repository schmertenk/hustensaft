extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_node("/root/Game/Particles").get_children():
		if c is CPUParticles2D:
			c.visible = Global.browser_mode
		else:
			c.visible = !Global.browser_mode
		
