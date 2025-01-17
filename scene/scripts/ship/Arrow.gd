class_name Arrow extends StaticBody3D

var response_time := 0.0
@export var target : Node3D


func _process(delta):
	if target != null:
		if response_time > 1:
			self.basis = get_parent().get_parent().basis
			look_at(target.global_position)
			
			response_time = 0
		response_time += delta
