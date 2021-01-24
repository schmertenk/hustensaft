extends StaticBody2D

export var max_x_shift = 200
export var max_y_shift = 100

var time = 4
var b = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	shift()



func shift():
	b = -b
	$Tween.interpolate_property(self, "position", self.position, Vector2(max_x_shift, max_y_shift) * b, time)
	$Tween.interpolate_callback(self, time + 1, "shift")
	$Tween.start()
