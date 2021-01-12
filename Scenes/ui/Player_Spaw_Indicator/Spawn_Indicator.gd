extends Node2D

var player setget set_player


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("show")
	
func stop():
	$AnimationPlayer.play("hide")

func set_player(value):
	player = value
	match player.color_char:
		"w": modulate = Color("#ffffff")
		"b": modulate = Color("#4444ff")
		"p": modulate = Color("#ff44ff")
		"o": modulate = Color("#ff4444")

func _process(_delta):
	position = player.get_global_transform_with_canvas().origin
