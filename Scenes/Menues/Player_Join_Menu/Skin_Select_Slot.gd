extends Control

class_name SkinSelectSlot

var player_info
var skins
var current_index = 0
var ready = false setget set_ready
var images = []

func _ready():
	skins = Global.skin_names.duplicate()
	for s in skins:
		images.append(load("res://Images/Characters/" + s + "/walk.png"))
	$VBoxContainer/Current_Container/Sprite.texture = images[0]
	$VBoxContainer/Player_Number.text = "Player " + str(player_info.id)
	$AnimationPlayer.play("walk")
	
	
func _input(event):
	var dir = 0
	if ready:
		return
	if event.device == player_info.joypad_id:
		if event.is_action_pressed("pad_ui_up") or event.is_action_pressed("pad_ui_down"):
			if event.is_action_pressed("pad_ui_up"):
				dir = 1
			else:
				dir = -1
		if event.is_action_pressed("pad_ui_accept"):
			self.ready = true
	elif player_info.joypad_id == -1:
		if event.is_action_pressed("key_ui_up") or event.is_action_pressed("key_ui_down"):
			if event.is_action_pressed("key_ui_up"):
				dir = 1
			else:
				dir = -1
		
		if event.is_action_pressed("keyboard_ui_accept"):
			self.ready = true
	
	current_index += dir

	if current_index < 0:
		current_index = skins.size() - 1 

	if current_index > skins.size() - 1 :
		current_index = 0
	
	if dir != 0:
		AudioManager.play("button_select")
		$VBoxContainer/Current_Container/Sprite.texture = images[current_index]

func set_ready(value):
	ready = value
	if ready:
		AudioManager.play("button_press")
		$TextureRect.modulate = Color(0.3,1,0.3)
		player_info.color_char = skins[current_index]
		
