extends TextureButton

export var button_text = "" setget set_button_text

func _pressed():
	AudioManager.play("button_press")

func _on_Start_focus_entered():
	AudioManager.play("button_select")

func set_button_text(value):
	button_text = value
	$Label.text = button_text
