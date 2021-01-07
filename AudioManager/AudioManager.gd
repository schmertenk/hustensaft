extends Node

var sound_script = load("res://AudioManager/ASP.gd")

export var sound_dictionary = {
	"main_menu_bgm" : ["res://Sounds/Music/8bit.ogg", "BGM"],
	"lvl_3_bgm" : ["res://Sounds/Music/backing_lvl_3.ogg", "BGM"],
	"laser_shot" : ["res://Sounds/Effects/Weapons/Laser_Shoot.wav", "SE"],
	"pistol_shot" : ["res://Sounds/Effects/Weapons/gunshot.wav", "SE"],
	"button_press" : ["res://Sounds/Effects/Press_Button.wav", "SE"],
	"button_select" : ["res://Sounds/Effects/Select_Button.wav", "SE"],
}
	
var player_dictionary = {
}

var playing_sounds = []
var playing_bgm = []
var playing_se = []

var sound_options = {
	"BGM" : {
		"volume" : 0,
		"pitch" : 1,
	},
	"SE" : {
		"volume" : 0,
		"pitch" : 1,
	},
}

func _ready():
	load_audio_players()
	pause_mode = PAUSE_MODE_PROCESS
	
func load_audio_players():
	for sound in sound_dictionary.keys():
		if player_dictionary.keys().find(sound) == -1:
			var player = AudioStreamPlayer.new()
			player.set_script(sound_script)
			player.sound_name = sound
			player.sound_type = sound_dictionary[sound][1]
			player.set_stream(load(sound_dictionary[sound][0]))
			player_dictionary[sound] = player
			player.connect("sound_finished", self, "_on_sound_finished")
			player.pause_mode = PAUSE_MODE_PROCESS
			add_child(player)

	
func play(sound_name, multiple = false, volume = null, pitch = null):
	if !player_dictionary.keys().has(sound_name):
		return
	var player = player_dictionary[sound_name]
	
	if pitch == null:
		pitch = sound_options[player.sound_type]["pitch"]
	if volume == null:
		volume = sound_options[player.sound_type]["volume"]
		
	
	player.volume_db = volume
	player.pitch_scale = pitch
	
	match player.sound_type:
		"BGM": playing_bgm.append(player)
		"SE": playing_se.append(player)
	playing_sounds.append(sound_name)
	
	if player.playing && multiple:
		var asp = player.duplicate(DUPLICATE_USE_INSTANCING)
		get_parent().add_child(asp)
		asp.stream = player.stream
		asp.play()
		yield(asp, "finished")
		asp.queue_free()
	else:
		player.play()
		

func stop(sound_name):
	var player = player_dictionary[sound_name]
	player.stop()
		
		
func is_playing(sound_name):
	return playing_sounds.find(sound_name) >= 0


func _on_sound_finished(player):
	if !player_dictionary[player.sound_name].playing:
		playing_sounds.erase(player.sound_name)
		
func stop_all_of_type(type):
	for player in get_all_souns_of_type(type):
		player.stop()
			
func get_all_souns_of_type(type):
	var arr = []
	match type:
		"BGM": arr = playing_bgm.duplicate()
		"SE": arr = playing_se.duplicate()
	return arr
			
func set_type_volume_db(type, value):
	sound_options[type]["volume"] = value
	for player in get_all_souns_of_type(type):
		player.volume_db = value
	
