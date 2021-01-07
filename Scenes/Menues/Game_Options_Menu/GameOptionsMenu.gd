extends Control

func _ready():
	$TransitionMask.slide_out()
	$VBoxContainer/CenterContainer2/HBoxContainer/Apply.grab_focus()
			
	set_select_box($VBoxContainer/CenterContainer/VBoxContainer/Sets_Per_Game/HBoxContainer, "sets")
	set_select_box($VBoxContainer/CenterContainer/VBoxContainer/Rounds_Per_Set/HBoxContainer, "rounds_per_set")
	set_select_box($VBoxContainer/CenterContainer/VBoxContainer/FX_Volume/HBoxContainer, "fx_volume")
	set_select_box($VBoxContainer/CenterContainer/VBoxContainer/BM_Volume/HBoxContainer, "bm_volume")
	
	if OS.window_fullscreen:
		$VBoxContainer/CenterContainer/VBoxContainer/Fullscreen/HBoxContainer/Select_Button2.select(false)
	else:
		$VBoxContainer/CenterContainer/VBoxContainer/Fullscreen/HBoxContainer/Select_Button.select(false)


func set_select_box(box, option_name):
	for c in box.get_children():
		if c.value == Global.options[option_name]:
			c.select(false)
			break;
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$TransitionMask.slide_in(Global, "go_to_menu", 0)

func _on_Dismiss_pressed():
	$TransitionMask.slide_in(Global, "go_to_menu", 0)


func _on_Apply_pressed():
	var settings = {
		"rounds_per_set" : int($VBoxContainer/CenterContainer/VBoxContainer/Rounds_Per_Set/HBoxContainer.value),
		"sets" : int($VBoxContainer/CenterContainer/VBoxContainer/Sets_Per_Game/HBoxContainer.value),
		"fullscreen" : $VBoxContainer/CenterContainer/VBoxContainer/Fullscreen/HBoxContainer.value,
		"bm_volume" : $VBoxContainer/CenterContainer/VBoxContainer/BM_Volume/HBoxContainer.value,
		"fx_volume" : $VBoxContainer/CenterContainer/VBoxContainer/FX_Volume/HBoxContainer.value,
	}
	
	Global.save_options(settings)
	Global.load_and_apply_options()

	$TransitionMask.slide_in(Global, "go_to_menu", 0)
