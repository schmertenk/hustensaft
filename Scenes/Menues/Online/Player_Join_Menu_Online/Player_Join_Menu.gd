extends Control

var keyboard_in = false
var p_count = 0
var slots = {}
var local_player_in = false
var info

func _ready():
	if Server.role == Server.ROLE_CLIENT:
		$IP.visible = true
	
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	for info in Global.player_infos:
		player_added(info)
	$AnimationPlayer.play("wiggle")
	$TransitionMask.slide_out()

func is_keyboard_in():
	if !keyboard_in:
		for info in Global.player_infos:
			if info.joypad_id == -1:
				return true
		return false
	else:
		return true

func _input(event):
	if local_player_in:
		return
	if event.is_action_pressed("ui_cancel") and slots.size() == 0:
		$Back.back()
	if event.is_action_pressed("pad_join_game") || event.is_action_pressed("keyboard_join_game"):
		var new = false
		if event.is_action_pressed("keyboard_join_game"):
			if !is_keyboard_in():
				keyboard_in = true
				new = true
		else:
			new = true
			for pi in Global.player_infos:
				new = new && pi.joypad_id != event.device
		if new:
			if Server.role == Server.ROLE_CLIENT:
				var peer = NetworkedMultiplayerENet.new()
				var address = $IP.text
				var err = peer.create_client(address, 6464)
				get_tree().network_peer = peer
				
			AudioManager.play("button_press")
			if event.is_action_pressed("keyboard_join_game"):
				info = Global.add_player_info(get_tree().get_network_unique_id(), -1, Server.own_player_info["nick_name"])
			else:
				info = Global.add_player_info(get_tree().get_network_unique_id(), event.device, Server.own_player_info["nick_name"])
			
			if Server.role == Server.ROLE_CLIENT:
				player_added(info)
			else:
				# host joined
				player_added(info)
				rpc("online_player_added", Server.own_player_info["nick_name"])

			local_player_in = true


func _player_connected(id):
	for slot in slots.values():
		rpc_id(id, "online_player_added", slot.player_info.nick_name, slot.current_index, slot.ready)

remote func online_player_added(nick_name, current_slot_index = 0, is_ready = false):
	var id = get_tree().get_rpc_sender_id()
	var info = Global.add_player_info(id, -2, nick_name)
	p_count += 1
	var slot = load("res://Scenes/Menues/Online/Player_Join_Menu_Online/Skin_Select_Slot.tscn").instance()
	slot.player_info = info
	slot.set_network_master(id)
	slot.name = "skin_slot" + str(id)
	slots[id] = slot
	slot.current_index = current_slot_index
	slot.ready = is_ready
	$VBoxContainer/HBoxContainer.add_child(slot)
	
func _process(_delta):
	$VBoxContainer/Label2.rect_pivot_offset = $VBoxContainer/Label2.rect_size / 2
	var all_ready = true
	
	for s in slots.values():
		all_ready = all_ready && s.ready
		
	if all_ready && slots.size() > 1 && Server.role == Server.ROLE_HOST:
		$VBoxContainer/CenterContainer/Next_Button.visible = true
		$VBoxContainer/CenterContainer/Next_Button.grab_click_focus()
		$VBoxContainer/CenterContainer/Next_Button.grab_focus()
	else:
		$VBoxContainer/CenterContainer/Next_Button.visible = false

		

func player_added(info):
	p_count += 1
	var slot = load("res://Scenes/Menues/Online/Player_Join_Menu_Online/Skin_Select_Slot.tscn").instance()
	slot.player_info = info
	slots[info.id] = slot
	slot.name = "skin_slot" + str(info.id)
	slot.set_network_master(info.id)
	$VBoxContainer/HBoxContainer.add_child(slot)
	slot.connect("back", self, "_on_back")

func _on_Next_Button_pressed():
	$TransitionMask.slide_in(get_tree(), "change_scene", "res://Scenes/Menues/Online/Secondarie_Select_menu_Online/Secondary_Select_Menu.tscn")
	rpc("all_players_in_and_ready")
	
remote func all_players_in_and_ready():
	if get_tree().get_rpc_sender_id() == 1:
		$TransitionMask.slide_in(get_tree(), "change_scene", "res://Scenes/Menues/Online/Secondarie_Select_menu_Online/Secondary_Select_Menu.tscn")

func _on_back():
	$Back.back()
