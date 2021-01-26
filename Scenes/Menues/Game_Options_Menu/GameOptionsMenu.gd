extends Control

var current_page = 0 setget set_current_page
onready var pages = [get_node("VBoxContainer/Pages/Gameplay"), get_node("VBoxContainer/Pages/Audio"), get_node("VBoxContainer/Pages/Video")]
onready var page_buttons = get_node("VBoxContainer/CenterContainer/HBoxContainer")


func _ready():
	$TransitionMask.slide_out()
	
	page_buttons.connect("value_changed", self, "set_current_page")

	set_select_box($VBoxContainer/Pages/Gameplay/Sets_Per_Game/HBoxContainer, "sets")
	set_select_box($VBoxContainer/Pages/Gameplay/Rounds_Per_Set/HBoxContainer, "rounds_per_set")
	set_select_box($VBoxContainer/Pages/Audio/FX_Volume/HBoxContainer, "fx_volume")
	set_select_box($VBoxContainer/Pages/Audio/BM_Volume/HBoxContainer, "bm_volume")
	set_select_box($VBoxContainer/Pages/Video/Graphic/HBoxContainer, "graphic_mode")
	if OS.window_fullscreen:
		$VBoxContainer/Pages/Video/Fullscreen/HBoxContainer/Select_Button2.select(false)
	else:
		$VBoxContainer/Pages/Video/Fullscreen/HBoxContainer/Select_Button.select(false)
		
	self.current_page = 0

func _process(delta):
		$VBoxContainer/Pages/Gameplay/Rounds_Per_Set/HBoxContainer/Select_Button2.grab_focus()
		set_process(false)

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
		"rounds_per_set" : int($VBoxContainer/Pages/Gameplay/Rounds_Per_Set/HBoxContainer.value),
		"sets" : int($VBoxContainer/Pages/Gameplay/Sets_Per_Game/HBoxContainer.value),
		"fullscreen" : $VBoxContainer/Pages/Video/Fullscreen/HBoxContainer.value,
		"graphic_mode" : $VBoxContainer/Pages/Video/Graphic/HBoxContainer.value,
		"bm_volume" : $VBoxContainer/Pages/Audio/BM_Volume/HBoxContainer.value,
		"fx_volume" : $VBoxContainer/Pages/Audio/FX_Volume/HBoxContainer.value,
	}
	
	Global.save_options(settings)
	Global.load_and_apply_options()

	$TransitionMask.slide_in(Global, "go_to_menu", 0)


func set_current_page(value):
	current_page = value
	for page in pages:
		if current_page == pages.find(page):
			page.visible = true
		else:
			page.visible = false



func _on_Gameplay_pressed():
	self.current_page = 0


func _on_Audio_pressed():
	self.current_page = 1


func _on_Video_pressed():
	self.current_page = 2
