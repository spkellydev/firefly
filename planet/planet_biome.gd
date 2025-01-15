@tool
class_name PlanetBiome extends Resource

@export var gradient : GradientTexture1D:
	set(g):
		gradient = g
		emit_signal("changed")
		if !gradient.is_connected("changed", bubble_signal_changed):
			gradient.connect("changed", bubble_signal_changed)
@export var start_height : float:
	set(h):
		start_height = h
		emit_signal("changed")

func bubble_signal_changed():
	emit_signal("changed")
