extends StaticBody2D

var players = []

func _ready():
	$AnimationPlayer.play("wiggle")

func _on_Area2D_body_entered(body):
	if body is Player:
		if !players.size():
			$Tween.interpolate_property($ufo_front, "modulate", $ufo_front.self_modulate, Color(1,1,1,0), 0.4)
			$Tween.start()
		players.append(body)
		


func _on_Area2D_body_exited(body):
	if body is Player:
		players.erase(body)
		if !players.size():
			$Tween.interpolate_property($ufo_front, "modulate", $ufo_front.modulate, $ufo_front.self_modulate, 0.4)
			$Tween.start()
