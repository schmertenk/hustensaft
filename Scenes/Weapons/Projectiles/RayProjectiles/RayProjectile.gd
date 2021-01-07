extends Projectile

class_name RayProjectile

export (String) var explosion_path
export (bool) var free_when_finished = true

var fire_range_random = 0
var ray
var fire_range
var initialized = false
var explosion_scene

func _ready():
	initialize()
	
func initialize():
	if fire_range != -1 && fire_range_random > 0:
		var _min = fire_range * (1 - fire_range_random)
		fire_range = rand_range(_min, fire_range)
	initialized = true
	explosion_scene = load(explosion_path)
	
func finish():
	if free_when_finished:
		queue_free()
	else:
		visible = false
		state = STATE_WAITING
		set_process(false)
