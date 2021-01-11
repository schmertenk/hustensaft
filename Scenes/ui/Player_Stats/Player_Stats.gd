extends Control

var player setget set_player
var offset = Vector2(70, -100)
onready var stack = get_node("VBoxContainer/HBoxContainer/Stack")

func _ready():
	if player:
		update()
	visible = false
		

func update():
	$VBoxContainer/bars/health.value = player.health
	$VBoxContainer/bars/shield.value = player.armor
	if player.weapon && player.weapon is ProjectileWeapon && player.weapon.is_power_weapon:
		$VBoxContainer/HBoxContainer/Stack.visible = true
		$VBoxContainer/HBoxContainer/Stack.text = str(player.weapon.shots_in_stack)
	else:
		$VBoxContainer/HBoxContainer/Stack.visible = false
	
func set_player(value):
	player = value
	$VBoxContainer/HBoxContainer/icon.texture = player.player_info.icon
	update()
	
