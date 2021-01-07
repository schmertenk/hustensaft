extends Secondary

class_name Stat_Buff

export (String) var stat
export (float) var value
export (float) var time

var done_value = 0

func use():
	state = STATE_IN_USE
	done_value = 0
	
func _process(_delta):
	if state == STATE_IN_USE:
		if time == 0:
			player.set(stat, float(player.get(stat)) + value)
			state = STATE_READY
			return
		
		var t = OS.get_ticks_msec() - last_used
		
		var amount = Helper.map(t, 0, time, 0, value) - done_value
		if done_value + amount >= value:
			amount = value - done_value
			state = STATE_READY
		
		done_value += amount
			
		player.set(stat, float(player.get(stat)) + amount)
