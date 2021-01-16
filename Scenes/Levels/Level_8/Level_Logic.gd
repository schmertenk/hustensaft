extends Node

onready var food = get_node("/root/Game/Assets/Food")

var players_in_pot = []
var weapons_spawned = false
var pot_damage_per_second = 40
var pot_weapon_dummies = []


func _ready():
	pot_weapon_dummies.append(load("res://Scenes/Weapons/ProjectileWeapons/Flame_Thrower/F_T_Dummy.tscn").instance())
	pot_weapon_dummies.append(load("res://Scenes/Weapons/ProjectileWeapons/Granade_Launcher/G_L_Dummy.tscn").instance())
	pot_weapon_dummies.append(load("res://Scenes/Weapons/ProjectileWeapons/Machine_Gun/M_G_Dummy.tscn").instance())
	pot_weapon_dummies.append(load("res://Scenes/Weapons/ProjectileWeapons/Shot_Gun/Shot_Gun_Dummy.tscn").instance())
func _process(delta):
	var d = pot_damage_per_second * delta
	for p in players_in_pot:
		p.damage(d, 1, 1)


func _on_pot_body_entered(body):
	if !food:
		food = get_node("/root/Game/Assets/Food")
	if body is Player:
		players_in_pot.append(body)
	elif body.get_parent() == food:
		if !weapons_spawned:
			$Timer.start()
		
func spawn_weapons():
	for w in pot_weapon_dummies:
		w.position = Vector2(494.661, 276)
		get_node("/root/Game/Weapons").add_child(w)
		randomize()
		var force = Vector2(rand_range(-0.5, 0.5), -1).normalized() * 2500
		w.apply_central_impulse(force)
		$Timer.stop()


func _on_Timer_timeout():
	spawn_weapons()


func _on_pot_body_exited(body):
	if body is Player:
		players_in_pot.erase(body)
