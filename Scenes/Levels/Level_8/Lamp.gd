extends Node2D

const STATE_OFF = 0
const STATE_ON = 1

var state = STATE_OFF setget set_state

func set_state(value):
	if value != state:
		if value == STATE_OFF:
			$CanvasModulate.visible = false
			$Lampshade/Light2D.enabled = false
		else:
			$CanvasModulate.visible = true
			$Lampshade/Light2D.enabled = true
	state = value


func _on_on_area_body_entered(body):
	if !body is Player:
		return
	set_state(STATE_ON)
	$Switch/off.visible = false
	$Switch/off/CollisionPolygon2D.set_deferred("disabled", true)
	$Switch/on.visible = true
	$Switch/on/CollisionPolygon2D.set_deferred("disabled", false)
	AudioManager.play("light_switch")


func _on_off_area_body_entered(body):
	if !body is Player:
		return
	set_state(STATE_OFF)
	$Switch/off.visible = true
	$Switch/off/CollisionPolygon2D.set_deferred("disabled", false)
	$Switch/on.visible = false
	$Switch/on/CollisionPolygon2D.set_deferred("disabled", true)
	AudioManager.play("light_switch")
