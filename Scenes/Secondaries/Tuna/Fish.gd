extends RigidBody2D

var player = null
var exception
var cat_count = 15
var ok = false
var spawned = false
var time = 6000
var eating = false
var started_eating = 0
var player_in_radius = []
var damage_per_second = 10
var affected_player = []
var cat_colors = [
	Color("#c2a034"),
	Color("#3a3a3a"),
	Color("#d5d5d5")]

signal eaten

func _on_Fish_body_entered(body):
	if body != exception && !ok && !spawned:
		ok = true


func _process(delta):
	if linear_velocity.length() < 0.5 && ok:
		ok = false
		spawn()
		
	if eating:
		for p in player_in_radius:
			p.damage(damage_per_second * delta, 1, 1, false, player)
			if affected_player.find(p) == -1:
				affected_player.append(p)
				p.mods["friction_speed_multiplier"] = 2
				p.mods["g_multiplier"] = 2
				p.lock_g(2000)
		if OS.get_ticks_msec() > started_eating + time:
			$Particles2D.emitting = false
			$Sprite.visible = false
			emit_signal("eaten")
		if OS.get_ticks_msec() > started_eating + time + $Particles2D.lifetime * 1000:
			for p in affected_player:
				player_in_radius.erase(p)
				p.mods["friction_speed_multiplier"] = p.original_mods["friction_speed_multiplier"]
				p.mods["g_multiplier"] = p.original_mods["g_multiplier"]
			queue_free()
			
func spawn():
	spawned = true
	for i in range(cat_count):
		var cat = load("res://Scenes/Secondaries/Tuna/Cat.tscn").instance()

		get_node("/root/Game").call_deferred("add_child", cat)
		var cam = get_node("/root/Game/Camera")
		
		randomize()
		
		var col = cat_colors[randi() % 3]
		var angle = rand_range(0, 2 * PI)
		var vec = Vector2(cos(angle), sin(angle))
		
		cat.global_position = cam.global_position + vec * cam.get_size_covered_by_camera().length()
		cat.fish = self
		cat.get_node("Sprite").modulate = col
		cat.connect("eat", self, "_on_cat_eating")
		cat.z_index = z_index - 1
		
func _on_cat_eating():
	eating = true
	if !started_eating:
		started_eating = OS.get_ticks_msec()
		$Affect_Area/CollisionShape2D.set_deferred("disabled", false)
	$Particles2D.emitting = true


func _on_Affect_Area_body_entered(body):
	if body is Player:
		player_in_radius.append(body)
		


func _on_Affect_Area_body_exited(body):
	if body is Player:
		player_in_radius.erase(body)
		body.mods["friction_speed_multiplier"] = body.original_mods["friction_speed_multiplier"]
		body.mods["g_multiplier"] = body.original_mods["g_multiplier"]
