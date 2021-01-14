extends Sprite

export (Vector2) var motion_scale = Vector2(1,1)
export (NodePath) var camera_path

onready var camera : Camera2D = get_node(camera_path)
onready var initial_position = position
func _process(_delta):
	position = camera.get_camera_screen_center() * motion_scale + initial_position

	
