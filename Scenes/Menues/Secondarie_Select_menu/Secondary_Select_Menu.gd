extends Control

class_name SecondarySelectMenu

export var slot_scene_path = "res://Scenes/Menues/Secondarie_Select_menu/Secondarie_Select_Slot.tscn"

var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$TransitionMask.slide_out()
	for info in Global.player_infos:
		var slot = load(slot_scene_path).instance()
		slot.player_info = info
		slots.append(slot)
		var c = $Dummy.duplicate()
		c.add_child(slot)
		$VBoxContainer/HBoxContainer.add_child(c)
		c.visible = true
		
		
func _process(delta):
	var all_ready = true
	for slot in slots:
		all_ready = all_ready && slot.ready
		
	if all_ready:
		all_ready()

func all_ready():
	if !$TransitionMask.is_active():
		$TransitionMask.slide_in(Global, "next_step")
