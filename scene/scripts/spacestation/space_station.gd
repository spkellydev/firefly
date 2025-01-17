extends Node3D

func _on_landing_zone_body_entered(body : Node3D):
	if body.is_in_group("ship"):
		DockingManager.emit_signal("landing_zone_activated", $LandingZone, body)
		

var delay = 0.0
func _ready():
	Globals.spacestation_coords = global_position

func _process(delta):
	if delay > 2.0:
		Globals.spacestation_coords = global_position
		delay = 0.0
	delay += delay
