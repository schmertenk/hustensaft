extends RigidBody2D

class_name RigidProjectile

signal hit

const STATE_STOPPED = 0
const STATE_FLYING = 1

export (float) var speed = 10
export (int) var flies_through = 1

var ignore_bodies = []
var initial_direction
var state = STATE_STOPPED
var weapon


func _physics_process(_delta):
	if state == STATE_STOPPED:
		apply_central_impulse(initial_direction * speed)
		state = STATE_FLYING

func _on_Bullet_body_entered(body):
	hit_target(body)
	
func hit_target(target):
	if !ignore_bodies.has(target):
		emit_signal("hit", target)
		do_damage(target)
		
func do_damage(target):
	target.damage(weapon.damage, weapon.armor_multiplier, weapon.flesh_multiplier, false, weapon.player)
