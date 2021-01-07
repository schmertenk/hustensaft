extends Node2D

signal over

const NET_RESTING = 0
const NET_FLYING = 1
const NET_STICKING = 2

var direction = Vector2.ZERO
var speed = 2000
var caught_player = null
var net_state = NET_RESTING
var sticky_time = 4000
var sticked_at = null
var excluded_player


func _physics_process(delta):
	if net_state == NET_FLYING:
		position += direction * speed * delta
	if caught_player:
		caught_player.global_position = global_position
	if net_state == NET_STICKING:
		var msec = OS.get_ticks_msec()
		if sticked_at == null:
			sticked_at = msec
		if msec > sticky_time + sticked_at:
			over()
	if global_position.length() > get_node("/root/Game").level_boundury_radius:
		over()

func over():
	if caught_player:
		caught_player.reset_mods()
	emit_signal("over")
	queue_free()
			

func _on_Hit_Box_body_entered(body):
	if body is Player and caught_player == null and net_state == NET_FLYING:
		if body != excluded_player:
			caught_player = body
	elif not body is RigidBody2D:
		if caught_player:
			caught_player.mods["frition_speed_multiplier"] = 0
			caught_player.mods["g_multiplier"] = 0
			net_state = NET_STICKING
		else:
			over()
