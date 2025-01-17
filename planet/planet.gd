@tool
class_name Planet extends RigidBody3D

var G = 6.6743 * pow(10, -2)
@export var initial_velocity = Vector3.ZERO
@export var is_star := false

var predicted_path := []
@export var planet_data : PlanetData:
	set(v):
		planet_data = v
		Globals.celestial_bodies.append(self)
		on_data_change()
		if planet_data != null and !planet_data.is_connected("changed", on_data_change):
			planet_data.connect("changed", on_data_change)

func _ready():
	linear_velocity = initial_velocity
	predicted_path = []
	on_data_change()

func calculate_gravity(p): 
	var total_force = Vector3() 
	for other_body in Globals.celestial_bodies: 
		if other_body != self: 
			var other_body_mass = other_body.mass 
			var direction = p - other_body.position 
			var distance = direction.length() 
			var force_mag = gravity_scale * ((mass * other_body_mass) / (distance * distance)) 
			var force = direction.normalized() * force_mag 
			total_force += -force 
	return total_force

func apply_gravity(_delta):
	predicted_path.clear()
	var current_position = global_position
	var current_velocity = linear_velocity
	
	# Simulate future positions
	for i in range(500):
		current_velocity += calculate_gravity(current_position) * _delta / mass
		current_position += current_velocity * _delta
		predicted_path.append(current_position)

	for other_body in Globals.celestial_bodies:
		if other_body != self:
			var other_body_mass = other_body.mass
			var direction = position - other_body.position
			var distance = direction.length()
			
			var idx = Globals.celestial_bodies.find(other_body)
			Globals.celestial_body_path.append(predicted_path)
			
			var force_mag = gravity_scale * ((mass * other_body_mass) / (distance * distance))
			var force = direction.normalized() * force_mag
			
			add_constant_central_force(-force)
			

func _physics_process(delta):
	if !is_star:
		apply_gravity(delta)
	else:
		linear_velocity = Vector3.ZERO

func on_data_change():
	planet_data.min_height = 99999.0
	planet_data.max_height = 0.0
	propagate_call("regenerate_mesh", [planet_data])


func _on_orbit_barrier_body_entered(body : Node3D):
	if body.is_in_group("player"):
		body.reparent(self)



func _on_orbit_barrier_body_exited(body):
	if body.is_in_group("player"):
		body.reparent(get_parent().get_parent())
