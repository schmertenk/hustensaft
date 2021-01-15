extends Node

class_name Menu

func _ready():
	Global.connect("game_paused", self, "_on_game_paused")
	if has_node("TransitionMask"):	
		$TransitionMask.slide_out()

func _on_game_paused():
	pass
