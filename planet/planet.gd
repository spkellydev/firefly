@tool
extends RigidBody3D

var G = 6.6743 * pow(10, -2)
@export var initial_velocity = Vector3.ZERO
@export var is_star := false

@export var planet_data : PlanetData:
	set(v):
		planet_data = v
		Globals.celestial_bodies.append(self)
		on_data_change()
		if planet_data != null and !planet_data.is_connected("changed", on_data_change):
			planet_data.connect("changed", on_data_change)

func _ready():
	linear_velocity = initial_velocity
	on_data_change()

func apply_gravity(_delta):
	for other_body in Globals.celestial_bodies:
		if other_body != self:
			var other_body_mass = other_body.mass
			var direction = position - other_body.position
			var distance = direction.length()
			
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
