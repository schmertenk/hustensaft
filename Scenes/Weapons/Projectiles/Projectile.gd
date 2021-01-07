extends Node2D

class_name Projectile

signal hit

const STATE_STOPPED = 0
const STATE_FLYING = 1
const STATE_WAITING = 2

var speed = 10
var flies_through = 1
var weapon = null
var ignore_bodies = []
var initial_direction
var state = STATE_STOPPED
	
func hit_target(target):
	if !ignore_bodies.has(target):
		emit_signal("hit", target, self)
		do_damage(target)
		
func do_damage(target):
	if target.has_method("damage"):
		target.damage(weapon.damage, weapon.armor_multiplier, weapon.flesh_multiplier, false, weapon.player)
