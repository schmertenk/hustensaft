extends TextureRect

export (float) var transition_time = 1.0

func _ready():
	rect_position.y -= rect_size.y / 2
	rect_size.y *= 2

func slide_out(callback_object = null, callback_function = null, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null):
	visible = true
	rect_pivot_offset.x = rect_size.x / 2
	rect_pivot_offset.x = rect_size.y * 1.5
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_rotation",
			0, 90, transition_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if callback_object && callback_function:
		tween.interpolate_callback(callback_object, transition_time, callback_function, arg1, arg2, arg3, arg4, arg5)
	tween.start()
	
func slide_in(callback_object = null, callback_function = null, arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null):
	visible = true
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_rotation",
			-90, 0, transition_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if callback_object && callback_function:
		tween.interpolate_callback(callback_object, transition_time, callback_function, arg1, arg2, arg3, arg4, arg5)
	tween.start()
	
func is_active():
	return $Tween.is_active()
