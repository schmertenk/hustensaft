extends Node

export (Array, String) var action_names
export (NodePath) var transition_mask = null

func _input(event):
	for a in action_names:
		if event.is_action_pressed(a):
			if transition_mask:
				get_node(transition_mask).slide_in(Global, "previous_step")
			else:
				Global.previous_step()
			return
