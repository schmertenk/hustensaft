extends Node

var planet_speeds = [10, 10, 50, 50]
onready var planets = get_node("/root/Game/Background/Planets").get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	for i in range(planets.size()):
		var p = planets[i]
		p.position.x += planet_speeds[i] * delta
