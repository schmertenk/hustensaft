extends Control

class_name Online_SecondarySelectMenu

export var slot_scene_path = "res://Scenes/Menues/Online/Secondarie_Select_menu_Online/Secondarie_Select_Slot.tscn"

var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.online_mode = true
	$TransitionMask.slide_out()
	for info in Global.player_infos:
		var slot = load(slot_scene_path).instance()
		slot.player_info = info
		slot.set_network_master(info.id)
		slot.name = "secondary_slot" + str(info.id)
		slots.append(slot)
		$VBoxContainer/HBoxContainer.add_child(slot)
		if has_node("Back"):
			slot.connect("back", $Back, "back")
		
		
func _process(_delta):
	var all_ready = true
	for slot in slots:
		all_ready = all_ready && slot.ready
		
	if all_ready && get_tree().get_network_unique_id() == 1:
		all_ready()


func all_ready():
	if has_node("Start"):
		$Start.visible = true

func _on_Start_pressed():
	Global.start_game()
