extends RigidProjectile

class_name ExplosiveRigidProjectile

const EXPLOSION_STATE_NOT_FIRED = 0
const EXPLOSION_STATE_TARGET_HIT = 1
const EXPLOSION_STATE_WAITING_FOR_RELEASE = 3
const EXPLOSION_STATE_EXPLODE = 2

export (String) var explosion_path
export (float) var explosion_radius setget set_explosion_radius
export (bool) var sticky = false

export (bool) var need_release = false
export (int) var delay_after_hit = 1000

export (Curve) var damage_curve
export (float) var explosion_knock_back = 10

var bodies_in_explosion_radius = []
var body_hit_time = 0
var explosion_state = EXPLOSION_STATE_NOT_FIRED
var last_global_positions = []
var pos_i = 0

onready var explosion_scene = load(explosion_path)

func _ready():
	$ExplosionRadius/CollisionShape2D.shape.radius = explosion_radius
	if need_release:
		explosion_state = EXPLOSION_STATE_WAITING_FOR_RELEASE

func hit_target(target):
	if !ignore_bodies.has(target):
		emit_signal("hit", target, self)
		var e = explosion_scene.instance()
		get_node("/root/Game").add_child(e)
		e.global_position = global_position
		e.explode()
		do_damage(target)
		queue_free()

func _on_Granade_body_entered(body):
	if explosion_state != EXPLOSION_STATE_TARGET_HIT && explosion_state != EXPLOSION_STATE_WAITING_FOR_RELEASE:
		explosion_state = EXPLOSION_STATE_TARGET_HIT
		body_hit_time = OS.get_ticks_msec()
		
	if sticky && !body.get("sticky"):
		call_deferred("handly_stickyness", global_position, body)
		
func _on_trigger_released():
	if explosion_state == EXPLOSION_STATE_WAITING_FOR_RELEASE:
		explosion_state = EXPLOSION_STATE_TARGET_HIT
		body_hit_time = OS.get_ticks_msec()
		
func handly_stickyness(original_hit_position, hit_body):
	get_parent().remove_child(self)

	hit_body.add_child(self)
	
	mode = MODE_STATIC
	linear_velocity = Vector2.ZERO
	$CollisionShape2D.disabled = true
	global_position = original_hit_position
	var index = clamp(pos_i, pos_i, max(0, last_global_positions.size() -1))
	var ray = RayCast2D.new()
	ray.enabled = true
	ray.cast_to = (global_position - last_global_positions[index]) * 3
	add_child(ray)
	global_position = last_global_positions[index]
	rotation_degrees = 0
	ray.add_exception(weapon.get_parent())
	ray.force_raycast_update()
	global_rotation = 0
	if ray.is_colliding():
		global_position = ray.get_collision_point()
	else:
		global_position = original_hit_position
	
	global_transform = Transform2D(0, global_position)
	
		

func _on_ExplosionRadius_body_entered(body):
	if !bodies_in_explosion_radius.has(body):
		bodies_in_explosion_radius.append(body)

func _on_ExplosionRadius_body_exited(body):
	if bodies_in_explosion_radius.has(body):
		bodies_in_explosion_radius.erase(body)

func set_explosion_radius(value):
	explosion_radius = value
	if has_node("ExplosionRadius/CollisionShape2D"):
		$ExplosionRadius/CollisionShape2D.shape.radius = explosion_radius

func _process(delta):
	if explosion_state == EXPLOSION_STATE_TARGET_HIT:
		if OS.get_ticks_msec() > body_hit_time + delay_after_hit:
			explosion_state = EXPLOSION_STATE_EXPLODE
	
	if explosion_state == EXPLOSION_STATE_EXPLODE:
		# null is ok brause the ExplosiveProjectileWeapon is handling the damage using zthe explosion_radius
		hit_target(null)
	last_global_positions.push_front(global_position)
	
func do_damage(target):
	var bodies = bodies_in_explosion_radius
	
	for body in bodies:
		if body is Player:
			var kb = explosion_radius - (global_position - body.global_position).length()
			var vec = (global_position - body.global_position).normalized() * -kb
			# more x than y to overcome players friction which is affecting only x
			vec.x *= 0.5 * explosion_knock_back
			vec.y *= 0.3 * explosion_knock_back
			body.knock_back(vec)
			var x = global_position.distance_to(body.global_position) / explosion_radius
			var d = 0
			if x > 0 and x <= 1:
				d = damage_curve.interpolate(x) * weapon.damage
			body.damage(d, weapon.armor_multiplier, weapon.flesh_multiplier, false, weapon.player)
		if body is RigidBody2D and not body is RigidDummy:
			var kb = explosion_radius - (global_position - body.global_position).length()
			var vec = (global_position - body.global_position).normalized() * -kb
			# more x than y to overcome players friction which is affecting only x
			body.apply_impulse(position, vec * explosion_knock_back / 2)



func _on_Granade_body_shape_entered(body_id, body, body_shape, local_shape):
	var arr = get_colliding_bodies()
	pass
