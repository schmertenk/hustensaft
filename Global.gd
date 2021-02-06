extends Node

const STATE_UNPAUSED = 0
const STATE_PAUSED = 1

const LOW_GRAPHIC_MODE = 0
const HIGH_GRAPHIC_MODE = 1

signal game_paused
signal game_unpaused
signal round_ended
signal new_round_started
signal new_set_started

signal online_players_level_loaded

var low_graphic_levels = ["Level_3", "Level_8", "Level_9", "Level_10"]

var save_file_name = "user://optionsdddd.json"
var options = {
	"rounds_per_set": 4,
	"sets": 3,
	"fullscreen" : 1,
	"fx_volume" : 5,
	"bm_volume" : 4,
	"graphic_mode": HIGH_GRAPHIC_MODE
}
var round_count = 0
var set_count = 0

# helper variable to prevent rushing back when pressed ui cancel
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
#var test_level = "res://Scenes/Levels/Level_3/Level.tscn"
var test_level = "res://Scenes/Levels/Level_10/Level.tscn"
var browser_mode = false
var secondarie_paths = [
	"res://Scenes/Secondaries/Armor_Recharger/Armor_Recharger.tscn",
	"res://Scenes/Secondaries/Gravity_Changer/Gravity_Changer.tscn",
	"res://Scenes/Secondaries/Tuna/Tuna.tscn",
	"res://Scenes/Secondaries/bounty/bounty.tscn",
	"res://Scenes/Secondaries/Net/Net_Thrower.tscn"
]

var skin_names = ["w", "o", "p", "b"]
var secondaries = []

var online_mode = false
var online_player_level_loaded_count = 0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	

func get_options_from_file():
	var file  = File.new()
	if file.open(save_file_name, File.READ) != 0:
		print("Error opening file")
		return {}

	var json = JSON.parse(file.get_as_text())
	file.close()
	if typeof(json.result) == TYPE_DICTIONARY:
		return json.result


func load_and_apply_options():
	var loaded_options = get_options_from_file()		
			
	for key in loaded_options.keys():
		if options.keys().has(key):
			options[key] = loaded_options[key]

	AudioManager.set_type_volume_db("BGM", options["bm_volume"])
	AudioManager.set_type_volume_db("SE", options["fx_volume"])
	OS.window_fullscreen = options["fullscreen"]
	

func save_options(new_options):
	var file = File.new()
	if file.open(save_file_name, File.WRITE) != 0:
		print("Error opening file")
		return
		
	for key in new_options.keys():
		if options.keys().has(key):
			options[key] = new_options[key]

	file.store_line(to_json(options))
	file.close()
		

func init():
	online_mode = false
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
	emit_signal("round_ended")
	current_menu_index = index
	get_tree().change_scene(menu_order[max(index, 0)])

func start_game():
	current_menu_index = 0
	set_count = 0
	round_count = 0
	if player_infos.size() == 1:
		one_player_mode = true
	else:
		one_player_mode = false
	
	for info in player_infos:
		info.win_count = 0
		info.lost_count = 0
	if online_mode:
		rpc("pre_online_game_start")
	start_new_set()
	start_new_round()

#special online fuctions
remotesync func pre_online_game_start():
	player_infos.sort_custom(self, "sort_ifos_by_id")
	
remote func online_player_level_load_finished(id):
	online_player_level_loaded_count += 1
	if online_player_level_loaded_count == player_infos.size() -1:
		emit_signal("online_players_level_loaded")
		
remote func online_change_level(lvl_path):
	get_tree().change_scene(lvl_path)
	
remote func recieve_win_counts(win_counts):
	for id in win_counts.keys():
		for info in player_infos:
			if info.id == id:
				info.win_count = win_counts[id]
				break
	
func sort_ifos_by_id(a, b):
	if typeof(a.id) != typeof(b.id):
		return typeof(a.id) < typeof(b.id)
	else:
		return a.id < b.id
	
	
remote func end_game():
	if online_mode:
		if Server.role == Server.ROLE_HOST: 
			rpc("end_game")
		get_tree().change_scene("res://Scenes/Menues/Online/AwardCeremony_Online/Award_Ceremony.tscn")
	else:
		get_tree().change_scene("res://Scenes/Menues/AwardCeremony/Award_Ceremony.tscn")
	
# winner is of type Player
# in online_mode this method is only called by the host
func end_round(winners):
	emit_signal("round_ended")
	var win_counts = {}
	for winner in winners:
		if winner:
			winner.player_info.win_count += 1
			win_counts[winner.player_info.id] = winner.player_info.win_count
	if online_mode:
		rpc("recieve_win_counts", win_counts)
	
	if round_count % int(options["rounds_per_set"]) == 0:
		if set_count == options["sets"]:
			set_count = 0
			end_game()
		else:
			start_new_set()
			if online_mode:
				rpc("intermiss")
			intermiss()
	else:
		start_new_round()
		
func start_new_round():
	round_count += 1
	emit_signal("new_round_started")
	online_player_level_loaded_count = 0
	change_to_next_level()

func start_new_set():
	emit_signal("new_set_started")
	set_count += 1

remote func intermiss():
	if Global.online_mode:
		get_tree().change_scene("res://Scenes/Menues/Online/Intermission_menu_Online/Intermission_Menu.tscn")
	else:
		get_tree().change_scene("res://Scenes/Menues/Intermission_menu/Intermission_Menu.tscn")
	
func add_player_info(player_id, joypad_id, nick_name = ""):
	var player_info = load("res://Scenes/Player/Player_Info.tscn").instance()
	player_info.id = player_id
	if nick_name == "":
		player_info.nick_name = str(player_id)
	else:
		player_info.nick_name = nick_name
	player_info.joypad_id = joypad_id
	player_infos.append(player_info)

	return player_info

	
func change_to_next_level():
	randomize()
	var lvls = Helper.list_files_in_directory("res://Scenes/Levels/")
	var lvl_number = randi()%lvls.size()
	
	var lvl_path : String

	if options["graphic_mode"] == LOW_GRAPHIC_MODE && low_graphic_levels.has(lvls[lvl_number]):
		lvl_path = "res://Scenes/Low_Graphic_Levels/" + lvls[lvl_number] + "/Level.tscn"
	else:
		lvl_path = "res://Scenes/Levels/" + lvls[lvl_number] + "/Level.tscn"
	
	
	if !test_mode:
		lvl_path = test_level

	var level = load(lvl_path)
	get_tree().change_scene_to(level)

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
