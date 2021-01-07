extends RayProjectile

class_name TravelRayProjectile

var traveling = true
var hit_target = null
var initial_position

func _ready():
	ray = RayCast2D.new()
	add_child(ray)
	
	for b in ignore_bodies:
		ray.add_exception(b)
	initialized = true
	rotation = initial_direction.angle()
	initial_position = global_position
	
func _process(delta):
	
	var velocity = initial_direction * speed * delta * 60
		
	if hit_target:
		hit_target(hit_target)
	else:
		ray.cast_to = Vector2(1,0) * velocity.length()
		ray.force_raycast_update()

	if ray.is_colliding():
		traveling = false
		global_position = ray.get_collision_point()
		hit_target = ray.get_collider()
		if explosion_path:
			var e = load(explosion_path).instance()
			get_node("/root/Game").add_child(e)
			e.global_position = ray.get_collision_point()
			e.explode()
	
	if traveling:
		global_position += velocity
		if fire_range != -1 and initial_position.distance_to(global_position) >= fire_range:
			queue_free()

func hit_target(target):
	.hit_target(target)
	queue_free()
