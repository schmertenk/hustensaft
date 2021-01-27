extends KinematicBody2D

class_name Player

signal weapon_droped
signal got_killed

export (int) var speed = 800
export (int) var jump_speed = -1500
export (int) var gravity = 5000
export (int) var p_number = 0 # the players id
export (float) var armor = 50 setget set_armor
export (float) var health = 100 setget set_health
export (float) var friction = 0.04
export (float) var mass = 3
export (float) var max_fall_speed = 2400

var color setget set_color
var icon = null
var last_move_direction = 0 # 1 for right, -1 for left
var invincible_against_player = [] # array of other players wich cannot hurt this player
var weapon setget set_weapon # the players weapon
var joypad_id = null # the id if the joypad. -1 if keyboard and mouse
var player_stats = null # the health and shield indicator on canvas layer
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var look_direction = Vector2.ZERO
var g = 1 # 1 is normal -1 is uside down
var pickupables_in_reach = [] # all objects in reach to pickup
var last_damage_time = 0
var secondary = null setget set_secondary # current secondary
var g_locked_time = 0 # gravity locked started
var g_locked_duration = 0 # gravity locking duration
var game # the current game object
var mouse_mode = false # if mouse mode is active, the players look_direction is towards the mouse pointer
var impuls = Vector2.ZERO
var player_info # player infos get saved in Global context
var dead = false

var hurt_sound_delay = 300
var last_hurt_sound_time = 0

# variables reguarding the animation
var walk_button_pressed = false
var in_jump = false

# the char that cooresponse to the path the right texture for the color lies
var color_char = null setget set_color_char

var original_mods = { 
	"friction_speed_multiplier" : 1,
	"g_multiplier" : 1,
	"suffered_damage_multiplier" : 1
}# some mods. original array is for resetting the mod and is read only

var mods = {} # is a duplication of original_mods for writing.


func _ready():
	for key in original_mods.keys():
		mods[key] = original_mods[key]
		
	if color:
		pass
		
	icon = load("res://Images/Characters/" + color_char + "/icon.png")
	var indicator = load("res://Scenes/ui/Out_Of_Screen_Indicator/Out_Of_Screen_Indicator.tscn").instance()
	indicator.player = self
	indicator.color = Color(1,1,1,1)
	game.get_node("CanvasLayer").add_child(indicator)

	initialize_animation("walk_l", "walk")
	initialize_animation("walk_r", "walk")
	initialize_animation("walk_l_back", "walk")
	initialize_animation("walk_r_back", "walk")
	initialize_animation("jump_l", "jump")
	initialize_animation("jump_r", "jump")
	initialize_animation("idle_l", "idle")
	initialize_animation("idle_r", "idle")
	initialize_animation("die_l", "die")
	
	update_labels()
	
	$Armor_Indicator.visible = false
	$Sprite.texture = load("res://Images/Characters/" + color_char + "/idle.png")
	$Beam/Timer.connect("timeout", self, "hide_beam")
	
func initialize_animation(a_name, image_name):
	var new_name = a_name + "_" + color_char

	$Movement_Animation_Player.add_animation(new_name, $Movement_Animation_Player.get_animation(a_name).duplicate())
	$Movement_Animation_Player.get_animation(new_name).track_set_key_value(0, 0, load("res://Images/Characters/" + color_char + "/" + image_name + ".png"))
	
func get_input(delta):
	walk_button_pressed = true
	if Input.is_action_pressed("p" + str(p_number) + "_right"):
		apply_force(Vector2(speed * mods["friction_speed_multiplier"], 0))
		last_move_direction = 1
	elif Input.is_action_pressed("p" + str(p_number) + "_left"):
		apply_force(Vector2(-speed * mods["friction_speed_multiplier"], 0))
		last_move_direction = -1
	else:
		walk_button_pressed = false


	if Input.is_action_pressed("p" + str(p_number) + "_use_secondary"):
		use_secondary()
		
	if Input.is_action_pressed("p" + str(p_number) + "_shoot"):
		pull_trigger()
		
	if Input.is_action_just_released("p" + str(p_number) + "_shoot"):
		release_trigger()
	
	if Input.is_action_just_pressed("p" + str(p_number) + "_pickup"):
		pickup_objects()
		
	if Input.is_action_just_pressed("p" + str(p_number) + "_change_g"):
		set_g(g * -1)
	if Input.is_action_just_pressed("p" + str(p_number) + "_jump"):
		if is_on_floor():
			in_jump = true
			AudioManager.play("jump", true)
			apply_force(Vector2(0, g * jump_speed))
	if Input.is_action_just_pressed("p" + str(p_number) + "_reload"):
		if weapon && weapon is ProjectileWeapon:
			weapon.start_reload()
	

func _physics_process(delta):
	if !player_stats.visible:	
		player_stats.visible = true
		
	if !dead:
		get_input(delta)
	
	# only apply gravity when in air or on steil slopes
	if !is_on_floor() || in_jump || get_slide_count() > 0 and abs(rad2deg(abs(get_slide_collision(0).normal.angle())) - 90) > 55:
		apply_force(Vector2(0, gravity * g * mods["g_multiplier"]))
	apply_force(Vector2(- (velocity.x * friction * mass * mods["friction_speed_multiplier"]), 0))

	impuls.x = lerp(impuls.x, 0, friction)
	apply_force(Vector2(impuls.x, 0))
	if abs(velocity.y) > max_fall_speed:
		if velocity.y < 0:
			velocity.y =-max_fall_speed
		else:
			velocity.y = max_fall_speed
	var snap = Vector2(0, 100 * g)
	if in_jump:
		snap = Vector2(0, 0)
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -g),
					true, 4, 0.959931, false)
	
	acceleration = Vector2.ZERO
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * 100)

func _process(_delta):
	if weapon:
		weapon.direction = look_direction
		if weapon.has_node("Spawn_Position"):
			$Crosshair.global_position = weapon.get_node("Spawn_Position").global_position
		else:
			$Crosshair.position = Vector2.ZERO
	else:
		$Crosshair.position = Vector2.ZERO
	
	$Crosshair/Sprite.scale = get_node("/root/Game/Camera").zoom / 2
	
	var last_look_direction = look_direction
	if !mouse_mode:
		var x = Input.get_joy_axis(joypad_id, JOY_AXIS_2)
		var y = Input.get_joy_axis(joypad_id, JOY_AXIS_3)
		if Vector2(x, y).length() < 0.1:
			x = 0
			y = 0
		look_direction = Vector2(x,y).normalized()
		if look_direction.length() <= 0.2:
			if velocity.x == 0:
				look_direction = Vector2(last_look_direction.x, 0)
			else:
				look_direction = Vector2(last_move_direction, 0)
	else:
		look_direction = (get_viewport().get_mouse_position() - get_global_transform_with_canvas().get_origin()).normalized()
		
	if g > 0:
		$Crosshair.rotation = look_direction.angle()
	else:
		$Crosshair.rotation = - look_direction.angle()
		
	if look_direction.x < 0:
		$Arm.rotation = (look_direction.angle() + PI) * g
		$Arm.scale = Vector2(-0.8, 0.8)
	else:
		$Arm.rotation = (look_direction.angle()) * g
		$Arm.scale = Vector2(0.8, 0.8)
		
	handle_animations()
	
	$Beam.global_scale = Vector2(1,1)
	
	if in_jump && is_on_floor():
		in_jump = false
	
	
func handle_animations():
	var look_r = look_direction.x >= 0
	if walk_button_pressed && is_on_floor():
		var walk_r = velocity.x > 0
		if look_r && walk_r:
			$Movement_Animation_Player.play("walk_r_" + color_char)
		elif !look_r && !walk_r:
			$Movement_Animation_Player.play("walk_l_" + color_char)
		elif look_r && !walk_r:
			$Movement_Animation_Player.play("walk_r_back_" + color_char)
		elif !look_r && walk_r:
			$Movement_Animation_Player.play("walk_l_back_" + color_char)
	elif in_jump:
		if look_r:
			$Movement_Animation_Player.play("jump_r_" + color_char)
		else:
			$Movement_Animation_Player.play("jump_l_" + color_char)
	elif !walk_button_pressed:
		if look_r:
			$Movement_Animation_Player.play("idle_r_" + color_char)
		else:
			$Movement_Animation_Player.play("idle_l_" + color_char)
			

func apply_force(force):
	acceleration += force;
	velocity += acceleration

func knock_back(i):
	impuls = Vector2(i.x / friction, i.y)
	apply_force(Vector2(0, i.y))
	in_jump = true


func pause():
	set_process(false)
	set_physics_process(false)

func unpause():
	set_process(true)
	set_physics_process(true)

func use_secondary():
	if !secondary:
		return
	
	secondary.activate()

func damage(damage, armor_multiplier = 1, flesh_multiplier = 1, ignore_armor = false, cause = null):
	if cause && invincible_against_player.find(cause) != -1:
		return
	damage *= mods["suffered_damage_multiplier"]
	last_damage_time = OS.get_ticks_msec()
	if !ignore_armor:
		var armor_damage = damage * armor_multiplier
		if armor >= armor_damage:
			self.armor -= armor_damage
			damage = 0
		else:
			var rest_armor_damage = armor_damage - armor
			armor = 0
			damage = rest_armor_damage / armor_multiplier
	$AnimationPlayer.play("armor_damaged")
	self.health -= damage * flesh_multiplier
	if health <= 0:
		die(cause)
	else:
		if OS.get_ticks_msec() > hurt_sound_delay + last_hurt_sound_time:
			last_hurt_sound_time = OS.get_ticks_msec()
			var i = randi() % 5 + 1
			AudioManager.play("hurt" + str(i), true)
	
func teleport(to_position):
	var last_position = global_position
	
	global_position = to_position

	$Beam/Line2D.clear_points()
	
	$Beam/Line2D.add_point(Vector2.ZERO, 0)
	$Beam/Line2D.add_point(last_position - global_position, 1)
	$Beam.visible = true
	$Beam/Timer.start()
	
func hide_beam():
	$Beam.visible = false

func die(cause):
	if dead:
		return
	dead = true
	$Crosshair.visible = false
	var i = randi()%5 + 1
	AudioManager.play("die" + str(i))
	if look_direction.x < 0:
		$Movement_Animation_Player.play("die_l_" + color_char)
	else: 
		$Movement_Animation_Player.play("die_l_" + color_char)
	drop_weapon()
	set_process(false)
	set_process_input(false)
	emit_signal("got_killed", cause)
	for p in game.players:
		if p != self:
			add_collision_exception_with(p)
	dead = true
	

func update_labels():
	if player_stats:
		player_stats.update()
	var r = armor / 100 
	if armor <= 0:
		$Armor_Indicator.visible = false
	else:
		$Armor_Indicator.visible = true
		
	$Armor_Indicator.modulate = Color(1, r, r)
	
func drop_weapon():
	if !weapon:
		return
	weapon.lay_down(global_position + Vector2(look_direction.x, 0).normalized() * 100, velocity)
	$Arm.remove_child(weapon)
	emit_signal("weapon_droped", weapon)
	weapon.player = null
	weapon = null
	player_stats.update()

func pull_trigger():
	if weapon:
		weapon.pull_trigger()
		if player_stats.stack.visible:
			player_stats.update()

func release_trigger():
	if weapon:
		weapon.release_trigger()
		
func reset_mods():
	mods = original_mods.duplicate()
		
func pickup_objects():
	if weapon:
		drop_weapon()
	if pickupables_in_reach.size():
		var obj = pickupables_in_reach[0]
		if obj is RigidDummy:
			self.weapon = obj.containing_weapon
			player_stats.update()
			obj.get_parent().remove_child(obj)

	
func set_weapon(w):
	if w == weapon:
		return
	if weapon:
		drop_weapon()
	
	weapon = w
	weapon.player = self
	weapon.position = Vector2(43.109, -17.927)
	$Arm.add_child(weapon)
	weapon.pick_up()
	
func set_secondary(value):
	if !value:
		return
	if secondary:
		remove_child(secondary)
	
	secondary = value
	secondary.player = self
	add_child(secondary)
				
func set_g(value, ignore_lock = false):
	if !ignore_lock && OS.get_ticks_msec() <= g_locked_time + g_locked_duration:
		return false
	
	AudioManager.play("gravity_flip", true)
	if g != value:
		scale.y *= -1
		g = value

	return true

func lock_g(duration):
	g_locked_duration = duration
	g_locked_time = OS.get_ticks_msec()
		
func set_health(value):
	health = value
	update_labels()
	
func set_armor(value):
	armor = value
	update_labels()

func set_color_char(value):
	color_char = value
	match color_char:
		"w" : self.color = Color("#dedede")
		"o" : self.color = Color("#ea8a4a")
		"b" : self.color = Color("#36abf1")
		"p" : self.color = Color("#ea4ae8")
		
func set_color(value):
	color = value
	$Crosshair.modulate = color

func _on_PickupBox_body_entered(body):
	if !pickupables_in_reach.has(body) && body.get("pickupable"):
		pickupables_in_reach.append(body)


func _on_PickupBox_body_exited(body):
	if pickupables_in_reach.has(body):
		pickupables_in_reach.erase(body)
