extends Node

var player
var camera

var is_paused

@export var celestial_bodies = []
@export var gravitational_constant = 0.0000000000674

@export var celestial_body_path = []
@export var spacestation_coords : Vector3 = Vector3.ZERO

func _ready():
	pass
	
func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
