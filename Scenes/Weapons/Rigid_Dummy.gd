extends RigidBody2D

class_name RigidDummy

export (String) var initial_weapon_path

var containing_weapon = null
var initialized = false

var pickupable = true
var tween : Tween
var initial_position = null
var initial_rotation = null

func _ready():
	tween = Tween.new()
	add_child(tween)
	if initial_weapon_path && containing_weapon == null:
		containing_weapon = load(initial_weapon_path).instance()

	initial_position = global_position
	initial_rotation = global_rotation
	add_to_group("weapons")
	can_sleep = false

		

func init():
	for p in get_node("/root/Game/Players").get_children():
		add_collision_exception_with(p)
		
	for w in get_tree().get_nodes_in_group("weapons"):
		add_collision_exception_with(w)
	containing_weapon.rigid_dummy = self

		
	initialized = true

	
func _process(_delta):
	if !initialized:
		init()

		
