extends SecondarySelectSlot

func get_seondaries():
	var secs = Global.secondaries.duplicate()
	
	for sec in secs:
		if sec.filename == player_info.secondary.filename:
			secs.erase(sec)
	
	return secs
