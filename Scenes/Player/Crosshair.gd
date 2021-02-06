extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RayCast2D.add_exception(get_parent())


func _process(_delta):
	if $RayCast2D.is_colliding():
		$Sprite.global_position = $RayCast2D.get_collision_point()
	else:
		$Sprite.position = Vector2(250, 0)
