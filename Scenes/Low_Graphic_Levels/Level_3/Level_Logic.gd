extends Node

var game

func _ready():
	AudioManager.insert_song_to_queue("Music Machine Mondays Theme Song", 0)
	
	game = get_node("/root/Game")
	for l in game.get_node("Lights").get_children():
		l.get_node("AnimationPlayer").play("spin")
		l.get_node("AnimationPlayer").playback_speed = rand_range(0.7, 1.2)
		if randi() % 2 + 1 == 1:
			l.scale.x *= -1

			
		l.modulate = Color(rand_range(0.5, 1), rand_range(0.5, 1), rand_range(0.5, 1), 0.5)
	
	game.get_node("DiscoLight/AnimationPlayer").play("spin")
	
