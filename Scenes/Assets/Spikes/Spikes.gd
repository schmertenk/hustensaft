extends Sprite



func _on_Area2D_body_entered(body):
	if body is Player:
		body.damage(body.health, 1, 1, true)
