extends Node

class_name PlayerInfo

var joypad_id
var win_count
var lost_count
var color
var id
var secondary
var color_char setget set_color_char
var icon

func set_color_char(value):
	color_char = value
	if value:
		icon = load("res://Images/Characters/" + color_char + "/icon.png")
	else:
		icon = null
