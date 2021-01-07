extends Camera2D

onready var game = get_node("/root/Game")

export (float) var min_zoom = 2
export (float) var max_zoom = 4.5

func _process(_delta):
	var m_y = 0
	var m_x = 0
	var fathest_p = null
	var fathest_dist = -1
	var players = game.get_living_players()
	if !players:
		return
	for player in players:
		if global_position.distance_to(player.global_position) > fathest_dist:
			fathest_dist = global_position.distance_to(player.global_position)
			fathest_p = player
		m_y += player.global_position.y
		m_x += player.global_position.x
	m_x = m_x / players.size()
	m_y = m_y / players.size()
	global_position = Vector2(m_x, m_y)
	set_zoom_to_capture_position(fathest_p.global_position)
	
	
func get_size_covered_by_camera():
	return get_viewport().size * zoom
	
func set_zoom_to_capture_position(position, margin = 300, smooth = 0.1):
	margin = get_viewport().size.y + margin
	var dist = (global_position - position).length()
	var z = (dist + margin) / (get_viewport().size.x / 2)
	
	z = clamp(z, min_zoom, max_zoom)
	
	zoom = zoom.linear_interpolate( (Vector2(z,z)), smooth)
