class_name OrbitAnchor extends Node3D

@export var rotation_speed := 0.05

func _physics_process(_delta):
	rotate_y(deg_to_rad(rotation_speed / 360.0))
