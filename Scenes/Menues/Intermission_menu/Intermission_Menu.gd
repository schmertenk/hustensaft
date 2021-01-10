extends SecondarySelectMenu

func all_ready():
	if !$TransitionMask.is_active():
		$TransitionMask.slide_in(Global, "start_new_round")

func _ready():
	for info in Global.player_infos:
		var l = get_node("VBoxContainer/HBoxContainer2/Label" + str(info.id))
		l.visible = true
		l.text = "Player " + str(info.id) + ": " + str(info.win_count) + " Wins"
