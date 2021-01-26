extends Secondary

var show_duration = 3000
var shown_at = 0
var hunted_player = null
var game
	
func use():
	game = get_node("/root/Game")
	randomize()
	var players = get_node("/root/Game").players
	var best_player = players[randi() % players.size() - 1]
	for p in players:
		if p.player_info.win_count > best_player.player_info.win_count:
			best_player = p
	
	best_player.connect("got_killed", self, "_on_best_player_killed")
	hunted_player = best_player
	for p in players:
		if p != best_player:
			for _p in players:
				if _p != best_player && _p != p:
					p.invincible_against_player.append(_p)
	$Tween.connect("tween_all_completed", self, "_on_tween_finished")
	play_indicator(best_player)
	
				
func play_indicator(player):
	shown_at = OS.get_ticks_msec()
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	$CanvasLayer/Sprite.position = get_viewport().size / 2
	$CanvasLayer/Sprite/Sprite.texture = player.icon
	AudioManager.play("wanted_poster")
	$AnimationPlayer.play("show")
		
func slide_to_corner():
	$Tween.interpolate_property($CanvasLayer/Sprite, "position", $CanvasLayer/Sprite.position, Vector2(get_viewport().size.x / 2, 55), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween2.interpolate_property($CanvasLayer/Sprite, "scale", Vector2(1, 1), Vector2(0.3, 0.3), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Tween2.start()
	
func _on_tween_finished():
	pause_mode = PAUSE_MODE_INHERIT
	state = STATE_READY
	Global.pause()
	Global.unpause()

func _on_best_player_killed(murder):
	if murder != hunted_player:
		game.end_round([murder])
	else:
		game.end_round([])
		
func _on_new_round_started():
	._on_new_round_started()
	$CanvasLayer/Sprite.visible = false
	
