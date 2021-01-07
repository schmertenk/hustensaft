extends Node

var planet_speeds = [50, 50, 10, 10]
onready var planets = get_node("/root/Game/Background/Planets").get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	for i in range(planets.size()):
		var p = planets[i]
		p.position.y += planet_speeds[i] * delta
