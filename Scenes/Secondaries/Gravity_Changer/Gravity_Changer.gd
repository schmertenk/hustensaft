extends Secondary

func use():
	state = STATE_READY
	for p in get_node("/root/Game").players:
		if p != player:
			if p.set_g(p.g * -1):
				p.lock_g(2000)
