extends TravelRayProjectile

export (float) var target_ray_length = 1000
export (float) var accuracy = 0.1
var target_ray : RayCast2D
var follow_target = null


func _ready():
	target_ray = RayCast2D.new()
	target_ray.enabled = true
	for b in ignore_bodies:
		target_ray.add_exception(b)
	add_child(target_ray)
	target_ray.cast_to = target_ray_length * Vector2.RIGHT
	
func _process(delta):
	if follow_target == null and \
		target_ray.is_colliding() and \
		target_ray.get_collider() is Player:
		follow_target = target_ray.get_collider()
		target_ray.enabled = false
	if follow_target:
		var d = (follow_target.global_position - global_position).normalized()
		direction = ((direction + d * accuracy)).normalized()
