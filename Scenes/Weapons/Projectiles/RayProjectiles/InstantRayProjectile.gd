extends RayProjectile

class_name InstantRayProjectile

export (int) var show_duration = 10

var shot_at
# line
var l


func _ready():
	ray = RayCast2D.new()
	ray.collide_with_bodies = true
	for e in ignore_bodies:
		ray.add_exception(e)
	
	add_child(ray)
	l = $Line2D

func init():
	.init()
	if fire_range == -1:
		fire_range = 1000000


func _process(_delta):
	if state == STATE_WAITING:
		return
	if state == STATE_STOPPED:
		ray.enabled = true
		state = STATE_FLYING
		ray.cast_to = initial_direction * fire_range
		shot_at = OS.get_ticks_msec()
		ray.force_raycast_update()
		if ray.get_collider():
			var b = ray.get_collider()
			draw_ray_line(ray.get_collision_point() - global_position)
			if explosion_scene:
				var e = explosion_scene.instance()
				e.global_position = ray.get_collision_point()
				get_node("/root/Game").add_child(e)
				e.explode()
			hit_target(b)
		else:
			draw_ray_line(ray.cast_to)
	else:
		ray.enabled = false
		if OS.get_ticks_msec() > shot_at + show_duration:
			finish()
		
		
	
	
func draw_ray_line(to_position):
	l.clear_points()
	l.add_point(Vector2.ZERO)
	l.add_point(to_position)
	l.z_index = -1
	l.visible = true
