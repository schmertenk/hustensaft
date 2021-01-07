extends Weapon

class_name ProjectileWeapon

export (int) var projectiles_per_shot = 1
export (String) var projectile_path
export (float) var projectile_speed = 10
export (float, 0, 2) var spray = 0
export (float) var fire_range = 1000
export (float, 0, 1) var fire_range_random = 0
export (int) var stack_size = 0
export (float) var reload_time = 0 # time the reloading process takes in seconds
export (bool) var can_reload = true
export (bool) var pool_projectiles = false

var projectile_scene
var shots_in_stack
var reload_tween : Tween
var projectile_pool = []
var used_projectile_pool = []

func _ready():
	shots_in_stack = stack_size
	if projectile_path:
		projectile_scene = load(projectile_path)
		
	reload_tween = Tween.new()
	add_child(reload_tween)
	if pool_projectiles:
		for i in range(stack_size * projectiles_per_shot):
			var p = make_projectile()
			projectile_pool.append(p)
			p.set_process(false)
			p.visible = false
			p.state = Projectile.STATE_WAITING
			p.free_when_finished = false
			get_node("/root/Game").add_child(p)
	
func start_reload():
	if reload_tween.is_active() || !can_reload:
		return
	reload_tween.interpolate_property($Sprite, "rotation_degrees", 0, 360, reload_time)
	reload_tween.interpolate_callback(self, reload_time, "finish_reload")

	reload_tween.start()
	
func finish_reload():
	shots_in_stack = stack_size
	
	if pool_projectiles:
		for p in used_projectile_pool:
			projectile_pool.append(p)
		used_projectile_pool.clear()
		
	reload_tween.stop_all()
	
func make_projectile():
	var p = projectile_scene.instance()
	p.weapon = self
	p.speed = projectile_speed
	if !direction:
		direction = Vector2.RIGHT
	if p is RigidProjectile:
		p.add_collision_exception_with(player)
	elif p is RayProjectile:
		p.fire_range = fire_range
		p.fire_range_random = fire_range_random
		if p is TravelRayProjectile:
			p.initial_position = global_position
	p.ignore_bodies.append(player)
		
	if p.has_method("_on_trigger_released"):
		connect("trigger_released", p, "_on_trigger_released")
	
	p.connect("hit", self, "on_projectile_hit")
		
	return p
	
func shoot():
	if shots_in_stack <= 0 && stack_size > 0:
		start_reload()
		return false
		
	if reload_tween.is_active():
		return false
		
	shots_in_stack -= 1
	
	var spawn_position = global_position
	if has_node("Spawn_Position"):
		spawn_position = $Spawn_Position.global_position
		
	if shoot_sound_name and AudioManager.sound_dictionary.keys().find(shoot_sound_name) != -1:
		AudioManager.play(shoot_sound_name, true)
			
	for i in range(projectiles_per_shot):
		var p
		if pool_projectiles:
			p = projectile_pool[projectiles_per_shot - 1 - i]
			projectile_pool.erase(p)
			used_projectile_pool.append(p)
			p.state = Projectile.STATE_STOPPED
			p.set_process(true)
			p.visible = true
		else:
			p = make_projectile()
			
		p.initial_direction = (direction + Vector2((0.5 - randf()) * spray, (0.5 - randf()) * spray)).normalized()
		# We havt to set initial_direction before adding the projectile to the scene
		if !pool_projectiles:
			get_node("/root/Game").add_child(p)
			
			
		p.global_position = spawn_position
		#p.rotation_degrees = 0
	return true
	
	
func on_projectile_hit(target, projectile):
	pass
		
func get_shoot_direction():
	pass

func pick_up():
	$Sprite.rotation_degrees = 0
	if reload_tween:
		reload_tween.stop_all()
