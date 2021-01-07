extends Node

class_name Menu

func _ready():
	Global.connect("game_paused", self, "_on_game_paused")

func _on_game_paused():
	pass
