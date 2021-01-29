extends Node

export (Array, String) var action_names
export (NodePath) var transition_mask = null

func _input(event):
	for a in action_names:
		if event.is_action_pressed(a):
			back()
			return
			
func back():
	AudioManager.play("button_cancel")
	if transition_mask:
		get_node(transition_mask).slide_in(Global, "previous_step")
	else:
		Global.previous_step()
	
