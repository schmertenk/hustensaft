extends RigidBody2D

class_name RigidDummy

export (String) var initial_weapon_path

var containing_weapon = null
var initialized = false

var pickupable = true
var tween : Tween

func _ready():
	tween = Tween.new()
	add_child(tween)
	if initial_weapon_path && containing_weapon == null:
		containing_weapon = load(initial_weapon_path).instance()
	
	add_to_group("weapons")
	can_sleep = false
		

func init():
	for p in get_node("/root/Game/Players").get_children():
		add_collision_exception_with(p)
		
	for w in get_tree().get_nodes_in_group("weapons"):
		add_collision_exception_with(w)
		
	initialized = true

	
func _process(_delta):
	if !initialized:
		init()

		
