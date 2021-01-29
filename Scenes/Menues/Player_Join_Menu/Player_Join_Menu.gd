extends Control

var keyboard_in = false
var p_count = 0
var slots = []

func _ready():
	for info in Global.player_infos:
		player_added(info)
	$AnimationPlayer.play("wiggle")
	$TransitionMask.slide_out()

func is_keyboard_in():
	if !keyboard_in:
		for info in Global.player_infos:
			if info.joypad_id == -1:
				return true
		return false
	else:
		return true
func _input(event):
	if event.is_action_pressed("ui_cancel") and slots.size() == 0:
		$Back.back()
	if event.is_action_pressed("pad_join_game") || event.is_action_pressed("keyboard_join_game"):
		var new = false
		if event.is_action_pressed("keyboard_join_game"):
			if !is_keyboard_in():
				keyboard_in = true
				new = true
		else:
			new = true
			for pi in Global.player_infos:
				new = new && pi.joypad_id != event.device
		if new:
			AudioManager.play("button_press")
			var info
			if event.is_action_pressed("keyboard_join_game"):
				info = Global.add_player_info(Global.player_infos.size() + 1, -1)
			else:
				info = Global.add_player_info(Global.player_infos.size() + 1, event.device)
			player_added(info)
	
func _process(_delta):
	$VBoxContainer/Label2.rect_pivot_offset = $VBoxContainer/Label2.rect_size / 2
	var all_ready = true
	
	for s in slots:
		all_ready = all_ready && s.ready
		
	if all_ready && slots.size() > 0:
		$VBoxContainer/CenterContainer/Next_Button.visible = true
		$VBoxContainer/CenterContainer/Next_Button.grab_click_focus()
		$VBoxContainer/CenterContainer/Next_Button.grab_focus()
	else:
		$VBoxContainer/CenterContainer/Next_Button.visible = false

func player_added(info):
	p_count += 1
	var slot = load("res://Scenes/Menues/Player_Join_Menu/Skin_Select_Slot.tscn").instance()
	slot.player_info = info
	slots.append(slot)
	var c = $Dummy.duplicate()
	c.add_child(slot)
	$VBoxContainer/HBoxContainer.add_child(c)
	slot.connect("back", self, "_on_back")
	c.visible = true


func _on_Next_Button_pressed():
	$TransitionMask.slide_in(Global, "next_step")
	
func _on_back():
	$Back.back()
