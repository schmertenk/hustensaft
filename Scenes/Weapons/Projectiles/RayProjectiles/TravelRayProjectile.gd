extends RayProjectile

class_name TravelRayProjectile

var traveling = true
var hit_target = null
var initial_position
var direction : Vector2
var travled_distance = 0

func _ready():
	ray = $RayCast2D
	for b in ignore_bodies:
		ray.add_exception(b)
	initialize()
	

func initialize():
	initial_direction = weapon.player.look_direction
	rotation = initial_direction.angle()
	direction = Vector2(initial_direction.x, initial_direction.y)
	initial_position = weapon.global_position
	traveling = true
	initialized = true
	ray.enabled = true
	hit_target = null
	travled_distance = 0
	
func _process(delta):
	if state == STATE_WAITING:
		return
	var velocity = direction * speed * delta * 60
	rotation = direction.angle()
		
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
		travled_distance += velocity.length()
		if fire_range != -1 and travled_distance >= fire_range:
			if free_when_finished:
				queue_free()
			else:
				visible = false
				state = STATE_WAITING
				set_process(false)
				ray.enabled = false

func hit_target(target):
	.hit_target(target)
	if free_when_finished:
		queue_free()
	else:
		visible = false
		state = STATE_WAITING
		set_process(false)
		ray.enabled = false
