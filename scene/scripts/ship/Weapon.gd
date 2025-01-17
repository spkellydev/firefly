extends MeshInstance3D

@export_range(0.0, 1.0) var speed_ratio = 0.0;
@export var flame_color = Color.from_string("00fff7", Color.WHITE):
	set(color):
		flame_color = color;
		material_override.albedo_color = color;
		material_override.emission = flame_color;
		
var _scale;

func _ready():
	_scale = scale;
	
func _process(_delta):
	scale = _scale * speed_ratio;

func fire():
	pass
