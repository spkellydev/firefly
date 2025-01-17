extends Node3D

const SPEED = 1200.0
@onready var mesh_instance_3d = $MeshInstance3D
@onready var ray_cast_3d : RayCast3D = $RayCast3D
@onready var gpu_particles_3d = $GPUParticles3D

var has_collided = false

func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, SPEED) * delta
	if has_collided:
		return
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider == null:
			return
		if collider.is_in_group("asteroid"):
				collider.get_parent().hit_bullet()
				
		has_collided = true
		mesh_instance_3d.visible = false
		# muzzle flash
		gpu_particles_3d.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

# delete the bullet after some time
func _on_timer_timeout():
	queue_free()
