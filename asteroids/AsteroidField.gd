extends Node3D
@export var target : Node
@onready var asteroid_pool = $AsteroidPool
var spawn_location

var asteroids : Array[MeshInstance3D]

func _ready():
	spawn_location = target.global_position
	while get_children().size() < 1000:
		for a in asteroid_pool.get_children():
			var asteroid : MeshInstance3D = a.duplicate()
			# add the collider to the asteroid group
			asteroid.get_child(0).add_to_group("asteroid")
			var scale = randi_range(50, 500)
			asteroid.scale = Vector3(scale,scale,scale)
			var has_ore = randi_range(1, 100)
			if has_ore > 70:
				asteroid.set_meta("ore", 1)
			
			add_child(asteroid)
			asteroids.append(asteroid)
			asteroid.global_position = Vector3(rand_offset(spawn_location.x), rand_offset(spawn_location.y), rand_offset(spawn_location.z))
			asteroid.visible = true

	
func rand_offset(f : float):
	return randf_range(-f - 1000, f + 1000)

