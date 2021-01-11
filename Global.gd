extends Node

const STATE_UNPAUSED = 0
const STATE_PAUSED = 1

signal game_paused
signal game_unpaused
signal new_round_started
signal new_set_started

var save_file_name = "user://settings.json"
var options = {
	"rounds_per_set": 2,
	"sets": 2,
	"fullscreen" : false,
	"fx_volume" : 0,
	"bm_volume" : 0,
}
var round_count = 0
var set_count = 0
var wait_for_ui_cancle_release = false
var current_menu_index = 0
var menu_order = [
	"res://Scenes/Menues/Main_Menu/Main_Menu.tscn",
	"res://Scenes/Menues/Player_Join_Menu/Player_Join_Menu.tscn",
	"res://Scenes/Menues/Secondarie_Select_menu/Secondary_Select_Menu.tscn"
]
var pause_state = STATE_UNPAUSED
var one_player_mode = false
var joypad_ids = []
var player_infos = []

var test_mode = false
var test_level = "res://Scenes/Levels/Level_9/Level.tscn"


var secondarie_paths = [
	"res://Scenes/Secondaries/Armor_Recharger/Armor_Recharger.tscn",
	"res://Scenes/Secondaries/Gravity_Changer/Gravity_Changer.tscn",
	"res://Scenes/Secondaries/Tuna/Tuna.tscn",
	"res://Scenes/Secondaries/bounty/bounty.tscn",
	"res://Scenes/Secondaries/Net/Net_Thrower.tscn"
]

var skin_names = ["w", "o", "p", "b"]
var secondaries = []

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	

func get_options_from_file():
	var file  = File.new()
	if file.open(save_file_name, File.READ) != 0:
		print("Error opening file")
		return

	var json = JSON.parse(file.get_as_text())
	file.close()
	if typeof(json.result) == TYPE_DICTIONARY:
		return json.result


func load_and_apply_options():
	var settings = get_options_from_file()
	if !settings:
		return
	options = settings
		
	AudioManager.set_type_volume_db("BGM", options["bm_volume"])
	AudioManager.set_type_volume_db("SE", options["fx_volume"])
	OS.window_fullscreen = options["fullscreen"]
	

func save_options(settings):
	var file = File.new()
	if file.open(save_file_name, File.WRITE) != 0:
		print("Error opening file")
		return

	file.store_line(to_json(settings))
	file.close()
		

func init():
	set_count = 0
	round_count = 0
	current_menu_index = 0
	pause_state = STATE_UNPAUSED
	secondaries = []
	joypad_ids = []
	player_infos = []
	
	load_and_apply_options()
	for f in secondarie_paths:
		var s = load(f).instance()
		if s.available:
			secondaries.append(s)
			
	for c in Input.get_connected_joypads():
		if Input.get_joy_name(c) == "XInput Gamepad":
			joypad_ids.append(c)

func next_step():
	if current_menu_index == menu_order.size() - 1:
		start_game()
	else:
		current_menu_index += 1
		go_to_menu(current_menu_index)

func previous_step(ui_cancel_pressed = true):
	if !wait_for_ui_cancle_release:
		if ui_cancel_pressed:
			wait_for_ui_cancle_release = true
		current_menu_index -= 1
		go_to_menu(current_menu_index)
		
func go_to_menu(index):
	current_menu_index = index
	get_tree().change_scene(menu_order[max(index, 0)])

func start_game():
	current_menu_index = 0
	if player_infos.size() == 1:
		one_player_mode = true
	
	for info in player_infos:
		info.win_count = 0
		info.lost_count = 0
	start_new_set()
	start_new_round()


func end_game():
	get_tree().change_scene("res://Scenes/Menues/AwardCeremony/Award_Ceremony.tscn")
	
# winner is of type Player
func end_round(winners):
	for winner in winners:
		if winner:
			winner.player_info.win_count += 1
	
	if round_count % int(options["rounds_per_set"]) == 0:
		if set_count == options["sets"]:
			set_count = 0
			end_game()
		else:
			start_new_set()
			intermiss()
	else:
		start_new_round()
		
func start_new_round():
	round_count += 1
	emit_signal("new_round_started")
	change_to_next_level()

func start_new_set():
	emit_signal("new_set_started")
	set_count += 1

func intermiss():
	get_tree().change_scene("res://Scenes/Menues/Intermission_menu/Intermission_Menu.tscn")
	
	
func add_player_info(player_id, joypad_id):
	var player_info = load("res://Scenes/Player/Player_Info.tscn").instance()
	player_info.id = player_id
	player_info.joypad_id = joypad_id
	player_infos.append(player_info)

	return player_info
	
func change_to_next_level():
	randomize()
	var lvls = Helper.list_files_in_directory("res://Scenes/Levels/")
	var lvl_number = randi()%lvls.size()

	if !test_mode:
		get_tree().change_scene("res://Scenes/Levels/" + lvls[lvl_number] + "/Level.tscn")
	else:
		get_tree().change_scene(test_level)

func _input(event):
	if event.is_action_pressed("game_pause"):
		if pause_state == STATE_PAUSED:
			unpause()
		else:
			pause()
			
	if event.is_action_released("ui_cancel") && wait_for_ui_cancle_release:
		wait_for_ui_cancle_release = false

func pause():
	pause_state = STATE_PAUSED
	emit_signal("game_paused")

func unpause():
	pause_state = STATE_UNPAUSED
	emit_signal("game_unpaused")
