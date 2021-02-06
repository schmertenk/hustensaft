extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Host_Button_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(6464, 4)
	get_tree().network_peer = peer
	Server.own_player_info["nick_name"] = $VBoxContainer/Nick_Name.text
	Server.role = Server.ROLE_HOST
	get_tree().change_scene("res://Scenes/Menues/Online/Player_Join_Menu_Online/Player_Join_Menu.tscn")


func _on_Join_Button_pressed():
	Server.own_player_info["nick_name"] = $VBoxContainer/Nick_Name.text
	Server.role = Server.ROLE_CLIENT
	get_tree().change_scene("res://Scenes/Menues/Online/Player_Join_Menu_Online/Player_Join_Menu.tscn")

	
