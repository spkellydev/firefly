extends Node3D

func _on_landing_zone_body_entered(body : Node3D):
	if body.is_in_group("ship"):
		DockingManager.emit_signal("landing_zone_activated", $LandingZone, body)
		
	
