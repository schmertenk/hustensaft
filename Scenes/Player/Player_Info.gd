extends Node

class_name PlayerInfo

# -1 = Keyboar, -2 = Online player, anything else = actual device id
var joypad_id
remote var win_count = 0
var lost_count
var color
var id
var secondary
var color_char setget set_color_char
var icon
var nick_name

func set_color_char(value):
	color_char = value
	if value:
		icon = load("res://Images/Characters/" + color_char + "/icon.png")
	else:
		icon = null
