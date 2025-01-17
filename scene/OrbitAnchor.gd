class_name OrbitAnchor extends Node3D

@export var rotation_speed := 0.05

func _physics_process(_delta):
	#rotate_y(deg_to_rad(rotation_speed / 360.0))
	pass


func _on_orbit_barrier_body_exited(_body):
	pass # Replace with function body.
