@tool
extends Node3D

@export var planet_data : PlanetData:
	set(v):
		planet_data = v
		on_data_change()
		if planet_data != null and !planet_data.is_connected("changed", on_data_change):
			planet_data.connect("changed", on_data_change)

func _ready():
	on_data_change()

func on_data_change():
	planet_data.min_height = 99999.0
	planet_data.max_height = 0.0
	propagate_call("regenerate_mesh", [planet_data])
