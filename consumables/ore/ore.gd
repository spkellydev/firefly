extends Node3D
var been_collected = false

@export var ore_data : OreData

# Called when the node enters the scene tree for the first time.
func _ready():
	ore_data.name = "IronOre"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and !been_collected:
		been_collected = true
		visible = false
		$AudioStreamPlayer.play()
		Inventory.update_ore(ore_data)
		await $AudioStreamPlayer.finished
		queue_free()
