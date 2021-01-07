extends HBoxContainer

class_name SelectButtonContainer

export (NodePath) var focus_up = null
export (NodePath) var focus_down = null

var buttons = []
var value = null

func _ready():
	for b in get_children():
		add_button(b)

func add_button(button):
	buttons.append(button)
	if button.get_parent() != self:
		add_child(button)
	button.connect("selected", self, "_on_button_selected")
	
	var n = buttons.size()-1
	if n > 0:
		get_child(n-1).focus_neighbour_right = button.get_path()
		button.focus_neighbour_left = get_child(n-1).get_path()
	
	if n == get_child_count() - 1:
		get_child(0).focus_neighbour_left = button.get_path()
		button.focus_neighbour_right = get_child(0).get_path()
	
	if focus_down:
		button.focus_neighbour_bottom = button.get_path_to(get_node(focus_down))
	if focus_up:
		button.focus_neighbour_top = button.get_path_to(get_node(focus_up))
		
func _on_button_selected(button):
	for b in buttons:
		if b == button:
			continue
		b.unselect()
	value = button.value
