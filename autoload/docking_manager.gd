extends Node

signal landing_zone_activated(landing_zone : Node3D, ship : Node3D)

func _ready():
	landing_zone_activated.connect(_handle_ship_landing)
	
func _handle_ship_landing(landing_zone : Node3D, ship : Node3D):
	if ship.get_parent().name != "LandingZone":
		get_parent().get_node("World").remove_child(ship)
		landing_zone.add_child(ship)
		print(landing_zone.global_position)
		ship.global_position = landing_zone.global_position
