# Out_Of_Screen_Indicator

extends Node2D

class_name OOSI

export (Color) var color = Color(1,1,1,1)

var player setget set_player

func _ready():
	modulate = color
	visible = false
	$AnimationPlayer.play("point")
	
func _process(_delta):
	var player_screen_position = player.get_global_transform_with_canvas().origin
	position.x = clamp(player_screen_position.x, 10, get_viewport().size.x - 10)
	position.y = clamp(player_screen_position.y, 10, get_viewport().size.y - 10)
	look_at(player_screen_position)
	$Sprite.global_rotation_degrees = rad2deg(player.velocity.angle()) + 90
func _on_player_screen_entered():
	visible = false
	

func _on_player_screen_exited():
	visible = true


func set_player(value):
	player = value
	player.get_node("VisibilityNotifier2D").connect("screen_entered", self, "_on_player_screen_entered")
	player.get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_player_screen_exited")
