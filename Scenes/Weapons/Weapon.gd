extends Node2D

signal trigger_released

class_name Weapon

export (float) var damage
export (float) var armor_multiplier
export (float) var flesh_multiplier
export (bool) var continues = false
export (String) var rigid_dummy_path

# time in millisecound needed to shoot the next shot / till next trigger pull shoots
export (float) var fire_rate = 200
# the sound name reffered in audiomanager
export (String) var shoot_sound_name

export (bool) var is_power_weapon = false

var trigger_pulled = false
var release_needed = false
var last_shot = 0
var direction
var player

func pull_trigger():
	if OS.get_ticks_msec() > last_shot + fire_rate and not release_needed:
		if not continues:
			release_needed = true
		if shoot():
			last_shot = OS.get_ticks_msec()

func release_trigger():
	release_needed = false
	emit_signal("trigger_released")

func get_dummy():
	var d = load(rigid_dummy_path).instance()
	d.containing_weapon = self
	return d

# returns wether the shot was successful or not
func shoot():
	return true
	
# do someting when layed down
func lay_down(_position, initial_velocity):
	var d = get_dummy()
	d.global_position = _position
	d.linear_velocity = initial_velocity
	d.rotation_degrees = randi() % 180
	get_node("/root/Game/Weapons").add_child(d)
	
# do someting when picked up
func pick_up():
	pass
	
	
