extends Secondary

func use():
	state = STATE_READY
	var dir = player.look_direction
	var fish = load("res://Scenes/Secondaries/Tuna/Fish.tscn").instance()
	fish.add_collision_exception_with(player)
	fish.exception = player
	get_node("/root/Game").add_child(fish)
	fish.global_position = player.global_position
	fish.apply_impulse(Vector2.ZERO, dir * 2000)
	fish.player = player
	
	
