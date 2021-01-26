extends RigidBody2D

signal eat

const STATE_SPAWN = 0
const STATE_HUNT = 1

var attraction_force = 50
var initial_force = 700
var fish setget set_fish
var eating = false
var fish_eaten = false
var spawn_position
var state = STATE_SPAWN

func _ready():
	spawn_position = global_position


	randomize()
	var r = rand_range(0.8, 1)
	var r1 = rand_range(0.95, 1)
	var dir = (fish.global_position - global_position).normalized()

	dir.x = dir.x * r1
	apply_central_impulse(dir * (initial_force * r))
	
	$AnimationPlayer.play("spawn")
	
func _physics_process(delta):

	rotation = linear_velocity.angle()
	if linear_velocity.x < 0:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
	if fish:
		var dir = (fish.global_position - global_position).normalized()
		if global_position.distance_to(fish.global_position) < 450 || eating:
			eating = true
			apply_central_impulse(dir * attraction_force)
			
	else:
		apply_central_impulse(Vector2(0,1) * attraction_force)
		if global_position.x > 10000:
			queue_free()
		


func _on_Area2D_body_entered(body):
	if body == fish:
		emit_signal("eat")
		var r = randi() %11 + 1
		AudioManager.play("cat" + str(r), false, false)
		
func _on_fish_eaten():
	fish = null

func set_fish(value):
	fish = value
	fish.connect("eaten", self, "_on_fish_eaten")
	
func set_state(value):
	state = value
