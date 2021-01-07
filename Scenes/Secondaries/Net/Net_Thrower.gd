extends Secondary

var net_scene

func _ready():
	net_scene = load("res://Scenes/Secondaries/Net/Net.tscn")

func use():
	var net = net_scene.instance()
	net.direction = player.look_direction.normalized()
	net.net_state = 1
	net.connect("over", self, "_on_net_over")
	net.excluded_player = player
	get_node("/root/Game").add_child(net)
	net.global_position = player.global_position
	state = STATE_IN_USE

func _on_net_over():
	state = STATE_READY
