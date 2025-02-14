class_name Ship extends CharacterBody3D

@export var max_speed := 50.0
@export var throttle := 15.0
@export var max_pitch := 90
@export var max_yaw := 40
@export var max_roll := 90
@export var acceleration := 0.6
@export var pitch_speed := 10
@export var roll_speed := 0.1
@export var yaw_speed := 0.1
@export var input_response := 1
@export var arrow_target : Node3D

var turbo = 3000.0
var turbo_acc = 350.0

var response_time = 0.0
var forward_speed = 0.0
var pitch_input = 0.0
var roll_input = 0.0
var yaw_input = 0.0

var in_orbit : bool = false

@onready var ship_body : Node3D = $ShipBody;
@onready var flames_left : Flames = $ShipBody/FlamesLeft;
@onready var flames_right : Flames = $ShipBody/FlamesRight;
@onready var horizon_lock = $HorizonLock
@onready var arrow = $Arrow

var in_turbo = false
#@onready var path_follow_3d = %PathFollow3D

var bullet : PackedScene= load("res://scene/scripts/ship/bullet.tscn")
var bullet_instance 

const BACKWARD_RATIO = 0.5;

func _ready():
	DockingManager.landing_zone_activated.connect(_handle_docking)
	arrow.target = arrow_target
	
func _handle_docking(_1, _2):
	in_orbit = true

func get_lerp_input(i, input_map_name1, input_map_name2, delta):
	return lerp(i, Input.get_action_strength(input_map_name1) - Input.get_action_strength(input_map_name2), input_response * delta)

func _input(_event : InputEvent):
	if in_orbit:
		Inventory.speed = 0.0
		return
		
		
	if Input.is_action_pressed("brake"):
		forward_speed = lerp(forward_speed, forward_speed / 4, 0.1)
	if Input.is_action_pressed("land"):
		if forward_speed != 0.0:
			forward_speed = lerp(forward_speed, 0.0, 0.9)
			acceleration = 0.0
	if Input.is_action_just_pressed("turbo"):
		if $TurboTimer.is_stopped():
			var maxs = max_speed
			var amax = throttle
			max_speed = turbo
			throttle = turbo_acc
			$TurboTimer.start()
			await $TurboTimer.timeout
			max_speed = maxs
			throttle = amax
		
	if Input.is_action_pressed("throttle"):
		if forward_speed < forward_speed + throttle:
			acceleration = 0.6
			forward_speed = clamp(forward_speed, forward_speed + throttle, max_speed)
		# makeshift attitude control
		var direction = sign(_get_relative_mouse().y)
		rotate_ship(lerp(0, 90, 0) * direction, lerp(0, 90, 0) * direction, lerp(0, 90, 0) * direction)

func move(delta):
	if in_orbit:
		return
	forward_speed = lerp(forward_speed, max_speed - throttle, acceleration * delta)
	Inventory.speed = forward_speed
	move_and_collide(transform.basis.z * delta * forward_speed)

func pitch():
	var mouse_speed = _get_relative_mouse()
	rotation_degrees.x += mouse_speed.y * pitch_speed
	var amount = abs(mouse_speed.y)
	var direction = sign(mouse_speed.y)
	return lerp(0, max_pitch, amount) * direction

func yaw():
	var mouse_speed = _get_relative_mouse()
	rotation_degrees.y -= mouse_speed.x * pitch_speed
	var amount = abs(mouse_speed.x)
	var direction = sign(mouse_speed.x)
	return lerp(0, max_yaw, amount) * direction
	
func roll():
	var mouse_speed = _get_relative_mouse()
	rotation_degrees.y -= mouse_speed.x * roll_speed
	var amount = abs(mouse_speed.x)
	var direction = sign(mouse_speed.x)
	var s  =  lerp(0, max_roll, amount) * direction
	return s


# Get a vector for the mouse relative to the center of the screen
# Range(-1, 1) negative is left/top positive is right/bottom
func _get_relative_mouse() -> Vector2:
	var viewport = get_viewport();
	var mouse_position = viewport.get_mouse_position();
	var center = viewport.size / 2.0;
	var mouse_direction = mouse_position - center;
	
	var size = max(viewport.size.x, viewport.size.y);
	return mouse_direction / size;

func rotate_ship(p, y, r):
	# Rotate Ship
	var ship_basis = Basis.IDENTITY;
	var s = ship_body.scale;
	ship_basis = ship_basis.rotated(Vector3.UP, deg_to_rad(p));
	ship_basis = ship_basis.rotated(Vector3.RIGHT, deg_to_rad(y));
	ship_basis = ship_basis.rotated(ship_basis.z, deg_to_rad(r));
	ship_basis = ship_basis.orthonormalized();
	ship_body.basis = ship_basis;
	ship_body.scale = s;

func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		bullet_instance = bullet.instantiate()
		bullet_instance.transform.basis = transform.basis
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = %WeaponRight.global_position
		bullet_instance = bullet.instantiate()
		bullet_instance.transform.basis = transform.basis
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = %WeaponLeft.global_position

func _process(delta):
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
		
	if !in_orbit:
		rotate_ship(pitch(), yaw(), roll())
		
	if horizon_lock.is_colliding():
		#var collider : Node3D = horizon_lock.get_collider() as Node3D
		#if collider.is_in_group("planetoid"):
		#	print("bingo baby oh yeah")
		pass
	if response_time > 1.0:
		Inventory.own_ship = global_position
		response_time = 0.0
	move(delta)
	response_time += delta
	if get_parent().name == "LandingZone":
		acceleration = 0.0
	# Flames
	if forward_speed > 0:
		flames_left.flame_color = Color.DEEP_SKY_BLUE;
		flames_right.flame_color = Color.DEEP_SKY_BLUE;
		flames_left.speed_ratio = forward_speed / max_speed;
		flames_right.speed_ratio = forward_speed / max_speed;
		
		if forward_speed > max_speed:
			flames_left.speed_ratio = 1
			flames_right.speed_ratio = 1
		
		#engine_material.albedo_color = Color.DEEP_SKY_BLUE.darkened(1.0 - flames_left.speed_ratio);
	elif Input.is_action_pressed("brake"):
		flames_left.flame_color = Color.HOT_PINK;
		flames_right.flame_color = Color.HOT_PINK;
		flames_left.speed_ratio = forward_speed / (max_speed * BACKWARD_RATIO);
		flames_right.speed_ratio = forward_speed / (max_speed * BACKWARD_RATIO);
		
		#engine_material.albedo_color = Color.HOT_PINK.darkened(1.0 - (forward_speed / (-max_speed * BACKWARD_RATIO)));
	else:
		#engine_material.albedo_color = Color.BLACK;
		flames_right.speed_ratio = 0.0;
		flames_right.speed_ratio = 0.0;


