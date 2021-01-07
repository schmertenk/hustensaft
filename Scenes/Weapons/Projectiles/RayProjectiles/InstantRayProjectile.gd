extends RayProjectile

class_name InstantRayProjectile

export (int) var show_duration = 10

var shot_at

# line
var l


func _ready():
	ray = RayCast2D.new()
	ray.collide_with_bodies = true
	ray.enabled = true
	for e in ignore_bodies:
		ray.add_exception(e)
	
	add_child(ray)

func init():
	.init()
	if fire_range == -1:
		fire_range = 1000000

func _process(delta):
	._process(delta)
	if state == STATE_STOPPED:
		state = STATE_FLYING
		ray.cast_to = initial_direction * fire_range
		shot_at = OS.get_ticks_msec()
		ray.force_raycast_update()
		if ray.get_collider():
			var b = ray.get_collider()
			draw_ray_line(ray.get_collision_point() - global_position)
			if explosion_path:
				var e = load(explosion_path).instance()
				e.global_position = ray.get_collision_point()
				get_node("/root/Game").add_child(e)
				e.explode()
			hit_target(b)
		else:
			draw_ray_line(ray.cast_to)
	else:
		ray.enabled = false
		if OS.get_ticks_msec() > shot_at + show_duration:
			queue_free()
		
		
	
	
func draw_ray_line(to_position):
	l = Line2D.new()
	l.add_point(Vector2.ZERO)
	l.add_point(to_position)
	l.z_index = -1
	l.default_color = Color(1,1,0,0.5)
	add_child(l)
