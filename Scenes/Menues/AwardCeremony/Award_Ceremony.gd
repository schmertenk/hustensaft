extends Control

func _ready():
	get_node("VBoxContainer/1st_place").rect_pivot_offset = get_node("VBoxContainer/1st_place").rect_size / 2
	
	$AnimationPlayer.play("wiggle")
	
	$TransitionMask.slide_out()
	var player = Global.player_infos.duplicate()
	
	player.sort_custom(self, "sort_for_wins")
	print(player)
	
	get_node("VBoxContainer/1st_place/name").text = "Player " + str(player[0].id)
	get_node("VBoxContainer/1st_place/wins").text = str(player[0].win_count) + " Wins"
	
	for i in range(player.size()):
		if i == 0:
			continue
		get_node("VBoxContainer/CenterContainer/ranks/" + str(i) + "/name").text = "Player " + str(player[i].id)
		get_node("VBoxContainer/CenterContainer/ranks/" + str(i) + "/wins").text = str(player[i].win_count) + " Wins"
		get_node("VBoxContainer/CenterContainer/ranks/" + str(i)).visible = true
	$VBoxContainer/HBoxContainer/CenterContainer2/Play_Again.focus_neighbour_left = $VBoxContainer/HBoxContainer/CenterContainer/Main_Menu.get_path()
	$VBoxContainer/HBoxContainer/CenterContainer/Main_Menu.focus_neighbour_right = $VBoxContainer/HBoxContainer/CenterContainer2/Play_Again.get_path()
	$VBoxContainer/HBoxContainer/CenterContainer2/Play_Again.grab_focus()

func sort_for_wins(a, b):
	return a.win_count > b.win_count


func _on_Main_Menu_pressed():
	$TransitionMask.slide_in(Global, "go_to_menu", 0)


func _on_Play_Again_pressed():
	$TransitionMask.slide_in(Global, "go_to_menu", 0)
