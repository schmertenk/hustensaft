extends Node2D

class_name Secondary

const STATE_READY = 0
const STATE_IN_USE = 1
const STATE_RELOADING = 2
const STATE_CANT_USE = 3

export (int) var reload_time
# 0 = infinite
export (int) var uses_per_round = 1
# 0 = infinite
export (int) var uses_per_set = 0
# 0 = Global Setlength
export (int) var set_length = 0
export (Texture) var icon
export (bool) var available = true
export (String) var _name
export (String) var description

var player
var last_used = 0
var state = STATE_READY
var round_uses_count = 0
var set_uses_count = 0

func _ready():
	Global.connect("new_round_started", self, "_on_new_round_started")
	if !set_length:
		set_length = int(Global.options["rounds_per_set"])


func _on_new_round_started():
	round_uses_count = 0
	if (Global.round_count - 1) % set_length == 0:
		set_uses_count = 0
	
func activate():
	if (OS.get_ticks_msec() > last_used + reload_time 
	and state == STATE_READY):
		if ((uses_per_round == 0 or uses_per_round > round_uses_count)
		and (uses_per_set == 0 or uses_per_set > set_uses_count)):
			use()
			last_used = OS.get_ticks_msec()
			round_uses_count += 1
			set_uses_count += 1
	
func use():
	pass # do your thing here
	
