extends StaticBody2D

const STATE_OFF = 0
const STATE_ON = 1


var players = []
var damage_per_secound = 200
var state = STATE_OFF
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_end")


func _process(delta):
	print(state)
	if state == STATE_OFF:
		return
	var d = damage_per_secound * delta
	for p in players:
		p.damage(d, 1, 1)
		p.knock_back(Vector2(-1, -1) * 200)


func _on_Timer_timeout():
	$AnimationPlayer.play("Fire")
	state = STATE_ON
	
func _on_animation_end(animation_name):
	$Timer.start()
	state = STATE_OFF
	

func _on_Area2D_body_entered(body):
	if body is Player:
		players.append(body)


func _on_Area2D_body_exited(body):
	if body is Player:
		players.erase(body)
