# Typical lobby implementation; imagine this being in /root/lobby.

extends Node

const ROLE_HOST = 0
const ROLE_CLIENT = 1

var player_network_infos = {}
var own_player_info = {"nick_name": "Vlad"}
var role = null

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", own_player_info)
		

func _player_disconnected(id):
	player_network_infos.erase(id) # Erase player from info.

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	print("connection_failed")

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_network_infos[id] = info
