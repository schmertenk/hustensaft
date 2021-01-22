extends Control

class_name SecondarySelectSlot

signal back

var player_info
var secondaries
var current_index = 0
var ready = false setget set_ready

func _ready():
	secondaries = get_seondaries()
	$VBoxContainer/Current_Container/Current.texture = secondaries[0].icon
	$VBoxContainer/Label.text = secondaries[0].description
	$VBoxContainer/CenterContainer/icon.texture = player_info.icon
	$VBoxContainer/Current_Container/Current.rect_pivot_offset = $VBoxContainer/Current_Container/Current.rect_size / 2
	$AnimationPlayer.play("wiggle")
	
	
func get_seondaries():
	return Global.secondaries.duplicate()
	
	
func _input(event):
	var dir = 0
	if event.device == player_info.joypad_id:
		if !ready:
			if event.is_action_pressed("pad_ui_up") or event.is_action_pressed("pad_ui_down"):
				if event.is_action_pressed("pad_ui_up"):
					dir = 1
				else:
					dir = -1
			if event.is_action_pressed("pad_ui_accept"):
				self.ready = true
		if event.is_action_pressed("pad_ui_cancel"):
			if !ready:
				emit_signal("back")
			else:
				self.ready = false
	elif player_info.joypad_id == -1:
		if !ready:
			if event.is_action_pressed("key_ui_up") or event.is_action_pressed("key_ui_down"):
				if event.is_action_pressed("key_ui_up"):
					dir = 1
				else:
					dir = -1
			
			if event.is_action_pressed("keyboard_ui_accept"):
				self.ready = true
		
		if event.is_action_pressed("keyboard_ui_cancel"):
			if !ready:
				emit_signal("back")
			else:
				self.ready = false
	
	current_index += dir

	if current_index < 0:
		current_index = secondaries.size() - 1 

	if current_index > secondaries.size() - 1 :
		current_index = 0
	
	if dir != 0:
		AudioManager.play("button_select")
		$VBoxContainer/Current_Container/Current.texture = secondaries[current_index].icon
		$VBoxContainer/Label.text = secondaries[current_index].description

func set_ready(value):
	ready = value
	if ready:
		AudioManager.play("button_press")
		$TextureRect.modulate = Color(0.3,1,0.3)
		player_info.secondary = secondaries[current_index].duplicate()
	else:
		AudioManager.play("button_press")
		$TextureRect.modulate = Color("#5a6d7d")
		player_info.secondary = null
		
