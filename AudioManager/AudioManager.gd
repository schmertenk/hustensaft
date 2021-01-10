extends Node

var sound_script = load("res://AudioManager/ASP.gd")

export var sound_dictionary = {
	"main_menu_bgm" : ["res://Sounds/Music/8bit.ogg", "BGM"],
	"lvl_3_bgm" : ["res://Sounds/Music/backing_lvl_3.ogg", "BGM"],
	"collish_stuff": ["res://Sounds/Music/Space_2_draft_C.ogg", "BGM"],
	
	"laser_shot" : ["res://Sounds/Effects/Weapons/Laser_Shoot.wav", "SE"],
	"pistol_shot" : ["res://Sounds/Effects/Weapons/gunshot.wav", "SE"],
	"shotgun_shot" : ["res://Sounds/Effects/Weapons/Shotgun.wav", "SE"],
	"grenade_launcher_shot" : ["res://Sounds/Effects/Weapons/grenade_launcher_1.wav", "SE"],
	"sticky_grenade_launcher_shot" : ["res://Sounds/Effects/Weapons/grenade_launcher_2.wav", "SE"],
	"flame_thrower_shot" : ["res://Sounds/Effects/Weapons/flame_sound.wav", "SE"],
	
	"medium_explosion" : ["res://Sounds/Effects/Explosions/explosion_grenade_1.wav", "SE"],
		
	"button_press" : ["res://Sounds/Effects/Press_Button.wav", "SE"],
	"button_select" : ["res://Sounds/Effects/Select_Button.wav", "SE"],
	
	"countdown_number": ["res://Sounds/Effects/3-2-1.wav","SE"],
	"countdown_go": ["res://Sounds/Effects/go.wav","SE"],
	
	"weapon_reload": ["res://Sounds/Effects/Weapons/reload.wav","SE"],
	
	"hurt1":["res://Sounds/Effects/Player/hit_1.wav", "SE"],
	"hurt2":["res://Sounds/Effects/Player/hit_2.wav", "SE"],
	"hurt3":["res://Sounds/Effects/Player/hurt1.wav", "SE"],
	"hurt4":["res://Sounds/Effects/Player/hurt2.wav", "SE"],
	"die":["res://Sounds/Effects/Player/die.wav", "SE"],
	
	"cat1": ["res://Sounds/Effects/cats/cat1.wav", "SE"],
	"cat2": ["res://Sounds/Effects/cats/cat2.wav", "SE"],
	"cat3": ["res://Sounds/Effects/cats/cat3.wav", "SE"],
	"cat4": ["res://Sounds/Effects/cats/cat4.wav", "SE"],
	"cat5": ["res://Sounds/Effects/cats/cat5.wav", "SE"],
	"fish": ["res://Sounds/Effects/cats/fish.wav", "SE"],
}
	
var player_dictionary = {
}

var playing_sounds = []
var playing_bgm = []
var playing_se = []

var bgm_queue = []
var bgm_queue_index = 0
var bgm_queue_playing = false

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
	randomaize_bgm_queue()


func get_all_bgm_names():
	var arr = []
	for sound_name in sound_dictionary.keys():
		if sound_dictionary[sound_name][1] == "BGM":
			arr.append(sound_name)
	return arr
	
func randomaize_bgm_queue():
	randomize()
	var bgms = get_all_bgm_names()
	bgm_queue_index = 0
	if bgms:
		for i in range(100):
			var r = randi() % bgms.size() - 1
			if bgms[r] == bgm_queue.back():
				if r == 0:
					r = bgms.size() -1
				else:
					r -= 1
			bgm_queue.append(bgms[r])
	
func play_bgm_queue(from_start = false):
	if from_start:
		bgm_queue_index = 0
	bgm_queue_playing = true
	play(bgm_queue[bgm_queue_index])
	player_dictionary[bgm_queue[bgm_queue_index]].connect("sound_finished", self, "_on_queue_sound_finished")
	bgm_queue_index += 1
func _on_queue_sound_finished(player : MyAudioStreamPlayer):
	player.disconnect("sound_finished", self, "_on_queue_sound_finished")
	if bgm_queue_playing:
		play_bgm_queue()

		

func stop_bgm_queue():
	bgm_queue_playing = false

	
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

	
func play(sound_name, multiple = false, interrupt = true, volume = null, pitch = null):
	
	if !interrupt && is_playing(sound_name):
		return
	
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
	
