extends Node2D

const STATE_COUNTDOWN = 0
const STATE_GOING = 1
const STATE_PAUSING = 2
const STATE_ENDING = 3
const STATE_ENDED = 4

var players
var count_down = 2500
var state = 0 setget set_state
var countdown_startet_at

export (int) var level_boundury_radius = 4000

func _ready():
	$CanvasLayer/Countdown.connect("finished", self, "_on_countdown_finished")
	Global.connect("game_paused", self, "_on_game_paused")
	Global.connect("game_unpaused", self, "_on_game_unpaused")
	var spawn_arr = [1,2,3,4]
	spawn_arr.shuffle()
	
	for i in range(Global.player_infos.size()):
		var p = load("res://Scenes/Player/Player.tscn").instance()
		p.global_position = $Spawns.get_node("Player_Spawn_" + str(spawn_arr[i+1])).global_position
		p.p_number = Global.player_infos[i].id
		p.joypad_id = Global.player_infos[i].joypad_id
		p.game = self
		p.secondary = Global.player_infos[i].secondary
		p.player_info = Global.player_infos[i]
		p.color_char = Global.player_infos[i].color_char
		var stat = load("res://Scenes/ui/Player_Stats/Player_Stats" + str(p.p_number) + ".tscn").instance()
		stat.player = p
		p.player_stats = stat
		$CanvasLayer/Player_Stats.add_child(stat)
		$Players.add_child(p)

	players = get_node("Players").get_children() 
	map_joypad_to_player()
	state = STATE_COUNTDOWN
	countdown_startet_at = OS.get_ticks_msec()
	
	if has_node("MovingPlatforms"):
		for c in $MovingPlatforms.get_children():
			c.add_to_group("moving_platforms")
	
	#pause the game initially for the transition
	$CanvasLayer/TransitionMask.slide_out()
	Global.pause()
	Global.unpause()

# called when pause signal of Global class is recieved
func _on_game_paused():
	if $CanvasLayer/Countdown.state == Countdown.STATE_RUNNING:
		Global.pause_state = Global.STATE_UNPAUSED
		return
	state = STATE_PAUSING
	pause()

# called when unpause signal of Global class is recieved
func _on_game_unpaused():
	if $CanvasLayer/Countdown.state == Countdown.STATE_RUNNING:
		Global.pause_state = Global.STATE_PAUSED
		return
	state = STATE_GOING
	unpause()

# called when Countdown is over
func _on_countdown_finished():
	get_tree().paused = false
	
func end_round(winners = null):
	if state == STATE_ENDED:
		return
	state = STATE_ENDED
		
	#removing players secondaiy, so it wont be freed
	for p in players:
		p.remove_child(p.secondary)
		p.secondary = null
	
	
	if winners == null:
		winners = get_living_players()
	
	# let transitionlayer slide in and then call Global.end_round() 
	$CanvasLayer/TransitionMask.slide_in(Global, "end_round", winners)

func _process(_delta):
	var living_players = get_living_players()
	if living_players.size() <= 1:
		if !Global.one_player_mode || !living_players.size():
			end_round()
	
	for p in living_players:
		if p.global_position.length() > level_boundury_radius:
			p.velocity = Vector2.ZERO
			p.global_position = $Spawns.get_node("Player_Spawn_" + str(p.p_number)).global_position
			p.damage(20, 1, 1, true)
func map_joypad_to_player():
	for i in range(players.size()):
		var p = players[i] 
		if p.joypad_id == -1:
			p.mouse_mode = true
			add_action_to_input_map("p" + str(p.p_number) + "_jump", 2, KEY_W, null)
			add_action_to_input_map("p" + str(p.p_number) + "_change_g", 2, KEY_SPACE, null)
			add_action_to_input_map("p" + str(p.p_number) + "_right", 2, KEY_D, null)
			add_action_to_input_map("p" + str(p.p_number) + "_left", 2, KEY_A, null)
			add_action_to_input_map("p" + str(p.p_number) + "_shoot", 3, BUTTON_LEFT, null)
			add_action_to_input_map("p" + str(p.p_number) + "_pickup", 2, KEY_E, null)
			add_action_to_input_map("p" + str(p.p_number) + "_use_secondary", 3, BUTTON_RIGHT, null)
			add_action_to_input_map("p" + str(p.p_number) + "_reload", 2, KEY_R, null)
		else:
			add_action_to_input_map("p" + str(p.p_number) + "_jump", 0, JOY_XBOX_A, p.joypad_id)
			add_action_to_input_map("p" + str(p.p_number) + "_change_g", 0, JOY_L, p.joypad_id)
			add_action_to_input_map("p" + str(p.p_number) + "_right", 1, JOY_AXIS_0, p.joypad_id, 1.0, 0.5)
			add_action_to_input_map("p" + str(p.p_number) + "_left", 1, JOY_AXIS_0, p.joypad_id, -1.0, 0.5)
			add_action_to_input_map("p" + str(p.p_number) + "_shoot", 0, JOY_R2, p.joypad_id,0 , 0)
			add_action_to_input_map("p" + str(p.p_number) + "_pickup", 0, JOY_XBOX_Y, p.joypad_id)
			add_action_to_input_map("p" + str(p.p_number) + "_use_secondary", 0, JOY_L2, p.joypad_id,0 , 0)
			add_action_to_input_map("p" + str(p.p_number) + "_reload", 0, JOY_XBOX_X, p.joypad_id)

#event types: 0 -> Button, 1 -> Axis, 2 -> Key, 3 -> MouseButton
func add_action_to_input_map(action_name, event_type, button_id, device_id, axis_value = -1.0, deadzone = 0.5):
	var ev
	if event_type == 0:
		ev = InputEventJoypadButton.new()
		ev.button_index = button_id
		ev.device = device_id
	elif event_type == 1:
		ev = InputEventJoypadMotion.new()
		ev.axis = button_id
		ev.axis_value = axis_value
		ev.device = device_id
	elif event_type == 2:
		ev = InputEventKey.new()
		ev.scancode = button_id
	elif event_type == 3:
		ev = InputEventMouseButton.new()
		ev.button_index = button_id

	if !InputMap.has_action(action_name):
		InputMap.add_action(action_name, deadzone)
	else:
		InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, ev)
	
	
func get_living_players():
	var arr = []
	for p in players:
		if p.health > 0:
			arr.append(p)
	return arr
	
	
func pause():
	get_tree().paused = true
	self.state = STATE_PAUSING
	

func unpause():
	self.state = STATE_COUNTDOWN
	
	
func set_state(value):
	if value == STATE_PAUSING:
		$CanvasLayer/Pause_Menu.show()
	if value == STATE_GOING:
		pass
	if value == STATE_COUNTDOWN:
		$CanvasLayer/Pause_Menu.hide()
		$CanvasLayer/Countdown.start()
		
	state = value
	

