extends Label

class_name Countdown

signal finished

const STATE_STOPPED = 0
const STATE_RUNNING = 1

export (int) var time = 2400
export (int) var devider = 600
export (String) var last_string = ""

var started_at
var state = 0

func _process(delta):
	if state == STATE_STOPPED:
		return
	
	if OS.get_ticks_msec() > started_at + time:
		state = STATE_STOPPED
		visible = false
		emit_signal("finished")
		return
		
	visible = true
	var sec = ceil((started_at + time - OS.get_ticks_msec()) / devider)
	if sec == 0 && last_string:
		text = last_string
	else:
		text = str(sec) 
		
	
func start():
	state = STATE_RUNNING
	started_at = OS.get_ticks_msec()
