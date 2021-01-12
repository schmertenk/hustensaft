extends Node2D

const STATE_CLOSED = 0
const STATE_OPEN = 1

var player_in_trigger = []
var state = STATE_CLOSED


func _ready():
	$MovingPlatform/AnimationPlayer.playback_speed = 6
	$MovingPlatform.to = $to_position.position
	$MovingPlatform.update_animations()
	$MovingPlatform/AnimationPlayer.connect("animation_started", self, "_on_anim_start")

func open():
	if $MovingPlatform/AnimationPlayer.is_playing():
		if $MovingPlatform/AnimationPlayer.get_queue().size() < 2:
			$MovingPlatform/AnimationPlayer.queue($MovingPlatform.move_to_name)
	else:
		$MovingPlatform/AnimationPlayer.play($MovingPlatform.move_to_name)
	state = STATE_OPEN

func close():
	if $MovingPlatform/AnimationPlayer.is_playing():
		if $MovingPlatform/AnimationPlayer.get_queue().size() < 2:
			$MovingPlatform/AnimationPlayer.queue($MovingPlatform.move_back_name)
	else:
		$MovingPlatform/AnimationPlayer.play($MovingPlatform.move_back_name)
	state = STATE_CLOSED

func _on_Trigger_Area_body_entered(body):
	if body is Player:
		player_in_trigger.append(body)
		if state == STATE_CLOSED:
			open()

func _on_Trigger_Area_body_exited(body):
	if body is Player:
		player_in_trigger.erase(body)
		if !player_in_trigger.size() && state == STATE_OPEN:
			close()
			
func _on_anim_start(anim_name):
	if anim_name == $MovingPlatform.move_back_name:
		AudioManager.play("door_close")
	if anim_name == $MovingPlatform.move_to_name:
		AudioManager.play("door_open")
