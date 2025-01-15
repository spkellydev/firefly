@tool
class_name PlanetNoise extends Resource

@export var min_height := 0.0:
	set(h):
		min_height = h
		emit_signal("changed")

@export var amplitude : float = 1.0:
	set(a):
		amplitude = a
		emit_signal("changed")
@export var noise_map : FastNoiseLite:
	set(n):
		noise_map = n
		emit_signal("changed")
		if noise_map != null and !noise_map.is_connected("changed", on_data_changed):
			noise_map.connect("changed", on_data_changed)
			
@export var use_first_layer_as_mask : bool = true:
	set(u):
		use_first_layer_as_mask = u
		emit_signal("changed")
		
func on_data_changed():
	emit_signal("changed")
