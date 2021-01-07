extends Node2D

class_name MovingPlatform

export (bool) var movign_r_on_default = true
export (bool) var is_child = false

var start_position = Vector2.ZERO
var move_r_name
var move_to_name
var move_back_name
var to

func _ready():
	if is_child:
		start_position = Vector2.ZERO
	else:
		start_position = Vector2(global_position.x, global_position.y)
	to = $to_position.global_position - global_position
	var new_name = str(randi() % 200000 + 100000)
	move_r_name = new_name + "r"
	move_to_name = new_name + "t"
	move_back_name = new_name + "b"
	
	update_animations()
	
	if movign_r_on_default:
		$AnimationPlayer.play(move_r_name)
	

func move_to():
	$AnimationPlayer.play(move_to_name)

func move_back():
	$AnimationPlayer.play(move_back_name)
	
func update_animations():
	$AnimationPlayer.add_animation(move_r_name, $AnimationPlayer.get_animation("move_r").duplicate())
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 0,  start_position)
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 1,  to / 2 + start_position)
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 2,  to + start_position)
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 3,  to + start_position)
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 4,  to / 2 + start_position)
	$AnimationPlayer.get_animation(move_r_name).track_set_key_value(0, 5,  start_position)
	
	$AnimationPlayer.add_animation(move_to_name, $AnimationPlayer.get_animation("move_to").duplicate())
	$AnimationPlayer.get_animation(move_to_name).track_set_key_value(0, 0,  start_position)
	$AnimationPlayer.get_animation(move_to_name).track_set_key_value(0, 1,  to / 2 + start_position)
	$AnimationPlayer.get_animation(move_to_name).track_set_key_value(0, 2,  to + start_position)
	$AnimationPlayer.get_animation(move_to_name).track_set_key_value(0, 3,  to + start_position)

	$AnimationPlayer.add_animation(move_back_name, $AnimationPlayer.get_animation("move_back").duplicate())
	$AnimationPlayer.get_animation(move_back_name).track_set_key_value(0, 0,  to + start_position)
	$AnimationPlayer.get_animation(move_back_name).track_set_key_value(0, 1,  to / 2 + start_position)
	$AnimationPlayer.get_animation(move_back_name).track_set_key_value(0, 2,  start_position)
	$AnimationPlayer.get_animation(move_back_name).track_set_key_value(0, 3,  start_position)

