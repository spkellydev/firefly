extends Node3D
@export var target : Node
@onready var asteroid_pool = $AsteroidPool
var ship_position

var asteroids : Array[MeshInstance3D]
const REWARD = preload("res://reward.tscn")

func _ready():
	ship_position = target.global_position
	while get_children().size() < 200:
		for a in asteroid_pool.get_children():
			var asteroid : MeshInstance3D = a.duplicate()
			# add the collider to the asteroid group
			asteroid.get_child(0).add_to_group("asteroid")
			asteroid.scale = Vector3(50,50,50)
			var has_ore = randi_range(1, 100)
			if has_ore > 90:
				asteroid.set_meta("ore", 1)
			
			add_child(asteroid)
			asteroids.append(asteroid)
			asteroid.global_position = Vector3(rand_offset(ship_position.x), rand_offset(ship_position.y), rand_offset(ship_position.z))
			asteroid.visible = true

	
func rand_offset(f : float):
	return randf_range(-f - 300, f + 300)

func check_asteroid_has_ore(a : MeshInstance3D):
	if a.has_meta("ore"):
		var reward = REWARD.instantiate()
		reward.transform.basis = a.transform.basis
		get_parent().add_child(reward)
		reward.global_position = a.global_position

func _process(_delta):
	for a in asteroids:
		# asteroid destroyed
		if a != null and a.is_queued_for_deletion():
			check_asteroid_has_ore(a)
