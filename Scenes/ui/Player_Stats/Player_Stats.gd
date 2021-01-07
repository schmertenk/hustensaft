extends Control

var player setget set_player
var offset = Vector2(70, -100)

func _ready():
	if player:
		update()
	visible = false
		
func _process(_delta):
	rect_position = player.get_global_transform_with_canvas().origin + (offset / get_node("/root/Game/Camera").zoom)
	rect_scale = Vector2(0.5,0.5) / get_node("/root/Game/Camera").zoom
func update():
	$VBoxContainer/health.value = player.health
	$VBoxContainer/shield.value = player.armor
	if player.weapon && player.weapon is ProjectileWeapon && player.weapon.is_power_weapon:
		$VBoxContainer/Stack.visible = true
		$VBoxContainer/Stack.text = str(player.weapon.shots_in_stack)
	else:
		$VBoxContainer/Stack.visible = false
	
func set_player(value):
	player = value
	update()
	
