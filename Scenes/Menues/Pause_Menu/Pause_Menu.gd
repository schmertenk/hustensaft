extends CenterContainer

onready var continue_button = get_node("Control/VBoxContainer/CenterContainer/Continue")
onready var exit_button = get_node("Control/VBoxContainer/CenterContainer2/Back_To_Menu")


func _on_Continue_pressed():
	Global.unpause()

func _on_Back_To_Menu_pressed():
	get_tree().paused = false
	get_node("/root/Game/CanvasLayer/TransitionMask").slide_in(Global, "go_to_menu", 0)

func show():
	continue_button.grab_focus()
	visible = true
	set_process(true)
	
func hide():
	visible = false
	set_process(false)

func _process(delta):
	var title = AudioManager.current_title
	if title == "Music Machine Mondays Theme Song":
		$Music/HBoxContainer/VBoxContainer/Artist.text = "Wintergatan"
	else:	
		$Music/HBoxContainer/VBoxContainer/Artist.text = "CarlaD"
		
	$Music/HBoxContainer/VBoxContainer/Title.text = title

func _on_Options_pressed():
	set_select_box($Options/VBoxContainer/CenterContainer/Music/SelectButtonContainer, "bm_volume")
	set_select_box($Options/VBoxContainer/CenterContainer2/FX/SelectButtonContainer, "fx_volume")
	set_select_box($Options/VBoxContainer/CenterContainer4/Fullscreen/SelectButtonContainer, "fullscreen")
	
	
	$AnimationPlayer.play("show_options")
	
func set_select_box(box, option_name):
	for c in box.get_children():
		if c.value == Global.options[option_name]:
			c.select(false)
			break;

func _on_Apply_pressed():
	var settings = {
		"bm_volume" : $Options/VBoxContainer/CenterContainer/Music/SelectButtonContainer.value,
		"fx_volume" : $Options/VBoxContainer/CenterContainer2/FX/SelectButtonContainer.value,
		"fullscreen": $Options/VBoxContainer/CenterContainer4/Fullscreen/SelectButtonContainer.value,
	}
	
	Global.save_options(settings)
	Global.load_and_apply_options()

	$AnimationPlayer.play("hide_options")


func _on_Dismiss_pressed():
	$AnimationPlayer.play("hide_options")
