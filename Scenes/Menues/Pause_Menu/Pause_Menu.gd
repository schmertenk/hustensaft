extends CenterContainer

onready var continue_button = get_node("Control/VBoxContainer/CenterContainer/Continue")
onready var exit_button = get_node("Control/VBoxContainer/CenterContainer2/Back_To_Menu")
# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.focus_neighbour_bottom = exit_button.get_path()
	exit_button.focus_neighbour_top = continue_button.get_path()


func _on_Continue_pressed():
	Global.unpause()

func _on_Back_To_Menu_pressed():
	get_tree().paused = false
	get_node("/root/Game/CanvasLayer/TransitionMask").slide_in(Global, "go_to_menu", 0)

func show():
	continue_button.grab_focus()
	visible = true
	
func hide():
	visible = false
