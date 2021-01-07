tool
extends Button

class_name SelectButton

signal selected

const STATE_UNSELECTED = 0
const STATE_ON_FOCUS = 1
const STATE_SELECTED = 2

export (Texture) var normal_texture
export (Texture) var selected_texture
export (Texture) var focused_texture
export (bool) var default_selected = false
export (float) var value = 0
export (String) var button_text = ""

var state = 0 setget set_state

func _ready():
	if default_selected:
		select()
	else:
		unselect()
		
	if button_text:
		$Label.text = button_text

func set_state(value):
	if value == STATE_UNSELECTED:
		$TextureRect.texture = normal_texture
	elif value == STATE_ON_FOCUS:
		$TextureRect.texture = focused_texture
	elif value == STATE_SELECTED:
		$TextureRect.texture = selected_texture
	state = value

func unselect():
	self.state = STATE_UNSELECTED

func focus():
	AudioManager.play("button_select")
	if state != STATE_SELECTED:
		self.state = STATE_ON_FOCUS

func select(play_sound = true):
	emit_signal("selected", self)
	if play_sound:
		AudioManager.play("Button_Press")
	self.state = STATE_SELECTED

func _pressed():
	select()

func _on_Select_Button_focus_entered():
	focus()

func _on_Select_Button_focus_exited():
	if state != STATE_SELECTED:
		unselect()
