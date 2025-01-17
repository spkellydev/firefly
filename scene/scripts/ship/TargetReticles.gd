extends Node3D

var camera

@onready var target_reticle = $TargetReticle
@onready var offscreen_reticle = $OffscreenReticle
@onready var main_reticle = $MainReticle

var reticle_offset = Vector2(32, 32)
var border_offser = Vector2(32, 32)
var viewport_center
var max_reticle_position

func _ready():
	camera = get_viewport().get_camera_3d()
	main_reticle.show()
	viewport_center = Vector2(get_viewport().size)/ 2.0
	max_reticle_position = viewport_center - border_offser

func _physics_process(_delta):
	var _space_state = get_world_3d().direct_space_state
	var origin = camera.project_ray_origin(main_reticle.position + reticle_offset) 
	var end = origin + camera.project_ray_normal(main_reticle.position + reticle_offset) * 40
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.exclude = [self, get_parent()] # exclude ship and reticle from search
	
	#var res = space_state.intersect_ray(query)
	#if "collider" in res:
#		var obj = res.collider
#		# found colliding object print(obj.name)
#		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#			if obj.name == "asteroid_collider":
#				obj.get_parent().queue_free()
#				Inventory.asteroid_ore += 1

func maintain_lock():
	pass

func _process(_delta):
	if camera.is_position_in_frustum(global_position):
		target_reticle.show()
		offscreen_reticle.hide()
		var _ret_pos = camera.unproject_position(global_position)
		target_reticle.position = get_viewport().get_mouse_position() - reticle_offset
		
		# lock onto starbase reticle
		if get_parent().is_in_group("starbase"):
			target_reticle.position = get_viewport().get_mouse_position() - reticle_offset
			var angle = Vector2.UP.angle_to(target_reticle.position)
			target_reticle.rotation = angle
		# main reticle lags behind the target position, mouse
		main_reticle.position = lerp(main_reticle.position, target_reticle.position, 0.1)
	else:
		target_reticle.hide()
		offscreen_reticle.show()
		var local_to_camera = camera.to_local(global_position)
		var ret_pos = Vector2(local_to_camera.x, -local_to_camera.y)
		if ret_pos.abs().aspect() > max_reticle_position.aspect():
			ret_pos *= max_reticle_position.x / abs(ret_pos.x)
		else:
			ret_pos *= max_reticle_position.y / abs(ret_pos.y)
		offscreen_reticle.set_global_position(viewport_center + ret_pos - reticle_offset)
		
		# rotate toward object
		var angle = Vector2.UP.angle_to(ret_pos)
		offscreen_reticle.rotation = angle
			
