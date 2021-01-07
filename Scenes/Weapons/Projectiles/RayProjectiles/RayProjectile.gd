extends Projectile

class_name RayProjectile

export (String) var explosion_path

var fire_range_random = 0
var ray
var fire_range
var initialized = false

func init():
	if fire_range != -1 && fire_range_random > 0:
		var _min = fire_range * (1 - fire_range_random)
		fire_range = rand_range(_min, fire_range)
	initialized = true
	
func _process(delta):
	if !initialized:
		init()
