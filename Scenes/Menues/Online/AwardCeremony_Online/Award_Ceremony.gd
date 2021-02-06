extends Control

func _ready():
	get_node("VBoxContainer/1st_place").rect_pivot_offset = get_node("VBoxContainer/1st_place").rect_size / 2
	
	get_node("VBoxContainer/1st_place/CenterContainer").visible = false
	get_node("VBoxContainer/1st_place/wins").visible = false
	$AnimationPlayer.play("wiggle")
	
	$TransitionMask.slide_out()
	var player = Global.player_infos.duplicate()
	
	player.sort_custom(self, "sort_for_wins")
	get_node("VBoxContainer/1st_place").rect_pivot_offset = get_node("VBoxContainer/1st_place").rect_size / 2
	get_node("VBoxContainer/1st_place/CenterContainer/icon").texture = player[0].icon
	get_node("VBoxContainer/1st_place/wins").text = str(player[0].win_count) + " Wins"
	
	for i in range(player.size()):
		if i == 0:
			continue
		var box = get_node("VBoxContainer/CenterContainer/ranks/" + str(i))
		box.get_node("icon").texture = player[i].icon
		box.get_node("wins").text = str(player[i].win_count) + " Wins"
	
	if player.size() > 1:
		get_node("VBoxContainer/CenterContainer/ranks/" + str(player.size() -1) + "/AnimationPlayer").play("show")
	else:
		$AnimationPlayer.play("show_winner")
	$VBoxContainer/HBoxContainer/CenterContainer/Main_Menu.grab_focus()


func _process(delta):
	get_node("VBoxContainer/1st_place").rect_pivot_offset = get_node("VBoxContainer/1st_place").rect_size / 2
	set_process(false)
	
func play_sound_for_rank(sound_name):
	AudioManager.play(sound_name)
	
func sort_for_wins(a, b):
	return a.win_count > b.win_count


func _on_Main_Menu_pressed():
	$TransitionMask.slide_in(Global, "go_to_menu", 0)


func _on_Play_Again_pressed():
	$TransitionMask.slide_in(Global, "start_game", 0)
