extends RigidProjectile

class_name Flame

# array holds array with 0 = body, 1 = time_when entered per body
var flameable_objects = []
var is_on = true
var player_invincibility_time = 0.1
var original_lifetime = 0


# lifetime in seconds
export (float) var lifetime = 3
export (float, 0, 1) var lifetime_random = 0

func _ready():
	for p in get_node("/root/Game/Players").get_children():
		add_collision_exception_with(p)
	var _min = lifetime * (1 - lifetime_random)
	lifetime = rand_range(_min, lifetime)
	lifetime += $Particles2D.lifetime
	original_lifetime = lifetime
	
	$brwoser_particles.visible = Global.browser_mode
	$Particles2D.visible = !Global.browser_mode

func _process(delta):
	for p in flameable_objects:
		if original_lifetime - lifetime < player_invincibility_time && p == weapon.player:
			continue
		p.damage(weapon.damage * delta, weapon.armor_multiplier, weapon.flesh_multiplier)
	
	lifetime -= delta
	if lifetime < $Particles2D.lifetime:
		$Particles2D.emitting = false
		$Light2D.enabled = false
	if lifetime <= 0:
		queue_free()


func _on_Flame_Area_body_entered(body):
	if body is Player:
		if body != weapon.player:
			apply_central_impulse(-linear_velocity / (150 * rand_range(0.7, 1.1)))
		flameable_objects.append(body)


func _on_Flame_Area_body_exited(body):
	flameable_objects.erase(body)
