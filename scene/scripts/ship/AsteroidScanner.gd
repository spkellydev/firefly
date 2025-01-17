class_name AsteroidScanner extends Node3D
const ASTEROID_ORE_SCANNED = preload("res://asteroids/asteroid_ore_scanned.tres")
const TARGET_RETICLES = preload("res://scene/scripts/ship/target_reticles.tscn")

func _input(_event):
	if Input.is_action_just_pressed("scan") and !$AnimationPlayer.is_playing():
		$AsteroidScannerArea/CollisionShape3D.disabled = false
		$AnimationPlayer.play("scan")
		await $AnimationPlayer.animation_finished
		$AsteroidScannerArea/CollisionShape3D.disabled = true

func _on_asteroid_scanner_area_body_entered(body : Node3D):
	if body.is_in_group("asteroid"):
		if body.get_parent().has_meta("ore"):
			body.get_parent().set_surface_override_material(0, ASTEROID_ORE_SCANNED)


func _on_asteroid_scanner_area_body_exited(body):
	if body.is_in_group("asteroid"):
		if body.has_meta("ore"):
			body.set_surface_override_material(0, null)


func _on_asteroid_scanner_area_max_body_entered(body):
	if body.is_in_group("asteroid"):
		if body.get_parent().has_meta("ore"):
			var reticles = TARGET_RETICLES.instantiate()
			reticles.name = "reticles"
			body.add_child(reticles)


func _on_asteroid_scanner_area_max_body_exited(_body):
		#if body.is_in_group("asteroid"):
		#	if body.get_parent().has_meta("ore"):
		#		var children = body.get_children()
		#		for c in children:
		#			if c.name == "reticles":
		#				c.queue_free()
		pass
