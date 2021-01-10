extends Node

var game

func _ready():
	#AudioManager.stop_all_of_type("BGM")
	#AudioManager.play("lvl_3_bgm")
	
	game = get_node("/root/Game")
	for l in game.get_node("Lights").get_children():
		l.get_node("AnimationPlayer").play("spin")
		l.get_node("AnimationPlayer").playback_speed = rand_range(0.7, 1.2)
		if randi() % 2 + 1 == 1:
			l.scale.x = -1
		else:
			l.scale.x = 1
			
		l.color = Color(rand_range(0.5, 1), rand_range(0.5, 1), rand_range(0.5, 1), 1)
	
	game.get_node("DiscoLight/AnimationPlayer").play("spin")
	game.get_node("DiscoLight2/AnimationPlayer").play("spin")
	
