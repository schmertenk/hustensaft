extends TextureButton

func _pressed():
	AudioManager.play("button_press")

func _on_Start_focus_entered():
	AudioManager.play("button_select")
