tool 
extends Node2D

export var r_speed = 0.1

var p = 0
var initial_position
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position

func _process(delta):
	p += r_speed * delta
	if p > PI:
		p = - PI
	$a.position.y = sin(p) * 100
	$b.position.y = - sin(p) * 100
