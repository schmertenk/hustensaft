extends Menu

var initialized = false

func _ready():
	initialized = false
	$TransitionMask.slide_out()


func _on_Start_pressed():
	$TransitionMask.slide_in(Global, "next_step")
	
	
func init():
	Global.init()
	initialized = true
	$VBoxContainer/CenterContainer2/Start.grab_focus()
	
	if !AudioManager.bgm_queue_playing:
		AudioManager.play_bgm_queue()


func _process(_delta):
	if !initialized:
		init()


func _on_Quit_pressed():
	$TransitionMask.slide_in(get_tree(), "quit")


func _on_Options_pressed():
	$TransitionMask.slide_in(get_tree(), "change_scene", "res://Scenes/Menues/Game_Options_Menu/GameOptionsMenu.tscn")
