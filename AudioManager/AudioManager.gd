extends Node

var sound_script = load("res://AudioManager/ASP.gd")

export var bgm_queue_pool = [
	"main_menu_bgm",
	"collish_stuff",
	"lvl_3_bgm",
]

export var sound_dictionary = {
	# MUSIC
	"main_menu_bgm" : ["res://Sounds/Music/8bit.ogg", "BGM", 1],
	"collish_stuff": ["res://Sounds/Music/Space_2_draft_C.ogg", "BGM", 1],
	"lvl_3_bgm" : ["res://Sounds/Music/backing_lvl_3.ogg", "BGM", 1],
	"lvl_8_bgm" : ["res://Sounds/Music/backing_lvl_8.ogg", "BGM", 1],
	
	#WEAPONS
	"laser_shot" : ["res://Sounds/Effects/Weapons/laser_gun.wav", "SE", 1],
	"pistol_shot" : ["res://Sounds/Effects/Weapons/pistol.wav", "SE", 1	],
	"mp_shot" : ["res://Sounds/Effects/Weapons/machine_gun.wav", "SE", 1	],
	"shotgun_shot" : ["res://Sounds/Effects/Weapons/shotgun.wav", "SE", 1],
	"grenade_launcher_shot" : ["res://Sounds/Effects/Weapons/grenade_launcher.wav", "SE", 1],
	"sticky_grenade_launcher_shot" : ["res://Sounds/Effects/Weapons/grenade_launcher_sticky.wav", "SE", 1],
	"flame_thrower_shot" : ["res://Sounds/Effects/Weapons/flamethrower.wav", "SE", 1],
	"needler_shot" : ["res://Sounds/Effects/Weapons/needler_whistle.wav", "SE", 1],
	
	"weapon_reload": ["res://Sounds/Effects/Weapons/reload_generic.wav","SE", 2],
	
	"medium_explosion" : ["res://Sounds/Effects/Explosions/explosion.wav", "SE", 1],
	
	#MENUES	
	"button_press" : ["res://Sounds/Effects/Menue/menu_button_select.wav", "SE", 1],
	"button_select" : ["res://Sounds/Effects/Menue/menu_button_hover.wav", "SE", 1],
	
	#General LEVEL SOUNDS
	"countdown_number": ["res://Sounds/Effects/general_game/countdown_321.wav","SE", 1],
	"countdown_go": ["res://Sounds/Effects/general_game/countdown_go.wav","SE", 1],
	
	"door_open": ["res://Sounds/Effects/general_game/door_open.wav", "SE", 2],
	"door_close": ["res://Sounds/Effects/general_game/door_close.wav", "SE", 2],
	
	
	
	#PLAYER SOUNDS
	"hurt1":["res://Sounds/Effects/Player/hurt/player_hurt_1.wav", "SE", 1],
	"hurt2":["res://Sounds/Effects/Player/hurt/player_hurt_2.wav", "SE", 1],
	"hurt3":["res://Sounds/Effects/Player/hurt/player_hurt_3.wav", "SE", 1],
	"hurt4":["res://Sounds/Effects/Player/hurt/player_hurt_4.wav", "SE", 1],
	"hurt5":["res://Sounds/Effects/Player/hurt/player_hurt_5.wav", "SE", 1],
	
	"die1":["res://Sounds/Effects/Player/die/player_death_1.wav", "SE", 1],
	"die2":["res://Sounds/Effects/Player/die/player_death_2.wav", "SE", 1],
	"die3":["res://Sounds/Effects/Player/die/player_death_3.wav", "SE", 1],
	"die4":["res://Sounds/Effects/Player/die/player_death_4.wav", "SE", 1],
	"die5":["res://Sounds/Effects/Player/die/player_death_5.wav", "SE", 1],
	
	"jump":["res://Sounds/Effects/Player/jump/player_jump_3.wav", "SE", 2],
	"gravity_flip":["res://Sounds/Effects/Player/gravity_flip/gravity_flip.wav", "SE", 1],
	
	
	# SECONDARIES
	"cat1": ["res://Sounds/Effects/secondaries/tuna/cats/cat_1.wav", "SE", 2],
	"cat2": ["res://Sounds/Effects/secondaries/tuna/cats/cat_2.wav", "SE", 2],
	"cat3": ["res://Sounds/Effects/secondaries/tuna/cats/cat_3.wav", "SE", 2],
	"cat4": ["res://Sounds/Effects/secondaries/tuna/cats/cat_4.wav", "SE", 2],
	"cat5": ["res://Sounds/Effects/secondaries/tuna/cats/cat_5.wav", "SE", 2],
	"cat6": ["res://Sounds/Effects/secondaries/tuna/cats/cat_6.wav", "SE", 2],
	"cat7": ["res://Sounds/Effects/secondaries/tuna/cats/cat_7.wav", "SE", 2],
	"cat8": ["res://Sounds/Effects/secondaries/tuna/cats/cat_8.wav", "SE", 2],
	"cat9": ["res://Sounds/Effects/secondaries/tuna/cats/cat_9.wav", "SE", 2],
	"cat10": ["res://Sounds/Effects/secondaries/tuna/cats/cat_10.wav", "SE", 2],
	"cat11": ["res://Sounds/Effects/secondaries/tuna/cats/cat_11.wav", "SE", 2],

	"fish1": ["res://Sounds/Effects/secondaries/tuna/fish/fish_1.wav", "SE", 2],
	"fish2": ["res://Sounds/Effects/secondaries/tuna/fish/fish_2.wav", "SE", 2],
	"fish3": ["res://Sounds/Effects/secondaries/tuna/fish/fish_3.wav", "SE", 2],
	
	
	"wanted_poster": ["res://Sounds/Effects/secondaries/bounty/wanted_poster_smack.wav", "SE", 1],
	
	
	
	# AWARD CEREMONY
	"4th": ["res://Sounds/Effects/award_ceremony/boo.wav", "SE", 1],
	"3rd": ["res://Sounds/Effects/award_ceremony/crickets.wav", "SE", 1],
	"2nd": ["res://Sounds/Effects/award_ceremony/slow_clap.wav", "SE", 1],
	"1st": ["res://Sounds/Effects/award_ceremony/applause.wav", "SE", 1],
	
	# Level content
	
	#LEVEL 8
	"ping": ["res://Sounds/Effects/Levels/Level_8/egg_timer_ding.wav", "SE", 1],
	"boiling_water": ["res://Sounds/Effects/Levels/Level_8/boiling_water.wav", "SE", 3],
	
	#LEVEL 11
	"rocket_engine" : ["res://Sounds/Effects/Levels/Level_11/rocket_engine.wav", "SE", 2],
	"running_rocket_engine": ["res://Sounds/Effects/general_game/engine/engine_running.wav", "SE", 3],
}
	
var player_dictionary = {
}

var playing_sounds = []
var playing_bgm = []
var playing_se = []

var bgm_queue = []
var bgm_queue_index = 0
var bgm_queue_playing = false

var looping_effects = []

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
	bgm_queue.clear()
	randomize()
	var bgms = bgm_queue_pool
	bgm_queue_index = 0
	if bgms:
		for _i in range(100):
			var r = randi() % bgms.size() - 1
			if bgm_queue && bgms[r] == bgm_queue.back():
				if r == 0:
					r = bgms.size() -1
				else:
					r -= 1
			bgm_queue.append(bgms[r])
	
func play_bgm_queue(from_start = false):
	if from_start:
		bgm_queue_index = 0
		stop_all_of_type("BGM")
	bgm_queue_playing = true
	play(bgm_queue[bgm_queue_index])
	player_dictionary[bgm_queue[bgm_queue_index]].connect("sound_finished", self, "_on_queue_sound_finished")

func play_next_in_queue():
	bgm_queue_index += 1
	play_bgm_queue()
	
# relative_position: 0 = play immediately, -1 = append
func insert_song_to_queue(sound_name = null, relative_position = 1):
	if !sound_name || !get_all_bgm_names().has(sound_name):
		return
	var pos = bgm_queue_index + relative_position
	if relative_position == -1:
		pos = bgm_queue.size()
	bgm_queue.insert(pos, sound_name)
	if relative_position == 0:
		if bgm_queue_playing:
			# set to false, in order to not count bgm_queue_index up when the current sound stops
			bgm_queue_playing = false
		stop_all_of_type("BGM")
		play_bgm_queue()
		

func _on_queue_sound_finished(player : MyAudioStreamPlayer):
	player.disconnect("sound_finished", self, "_on_queue_sound_finished")
	if bgm_queue_playing:
		bgm_queue_index += 1
		if bgm_queue_index >= 100:
			bgm_queue_index = 0
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
			player.volume_mod = sound_dictionary[sound][2]
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

	var current_p = pow(10, volume / 100)
	match player.volume_mod:
		2: volume = 100 * (log(current_p - 0.1) / 2.302585)
		3: volume = 100 * (log(current_p - 0.2) / 2.302585)
	
	if is_nan(volume):
		volume = -80
	
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
		
func loop(name):
	if looping_effects.has(name):
		return
	looping_effects.append(name)
	player_dictionary[name].connect("sound_finished", self, "looping_effect_stopped")
	play(name)

	
func looping_effect_stopped(player):
	play(player.sound_name)
	
func stop_loop(name):
	player_dictionary[name].disconnect("sound_finished", self, "looping_effect_stopped")
	stop(name)
	looping_effects.erase(name)
	
func stop_all_looping():
	for effect_name in looping_effects:
		stop_loop(effect_name)

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
	if value == null:
		return
	if type != "BGM" && type != "SE":
		return
		
	sound_options[type]["volume"] = value
	for player in get_all_souns_of_type(type):
		player.volume_db = value
	
