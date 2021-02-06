extends Online_SecondarySelectMenu

func all_ready():
	if get_tree().get_network_unique_id() == 1:
		$Next.visible = true

func _ready():
	var c = 0
	for info in Global.player_infos:
		c += 1
		var l = get_node("VBoxContainer/HBoxContainer2/Label" + str(c))
		l.visible = true
		l.text = info.nick_name + " : " + str(info.win_count) + " Wins"


func _on_Next_pressed():
	if !$TransitionMask.is_active():
		$TransitionMask.slide_in(Global, "start_new_round")
