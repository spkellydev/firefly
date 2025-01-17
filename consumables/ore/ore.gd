extends Node3D
var been_collected = false
var id : int

@export var ore_data : OreData

# Called when the node enters the scene tree for the first time.
func _ready():
	id = randi_range(0, 20000)
	ore_data.id = id
	ore_data.name = "IronOre"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and !been_collected:
		been_collected = true
		if !Inventory.ore.has(id):
			visible = false
			$AudioStreamPlayer.play()
			Inventory.update_ore(id, ore_data)
			await $AudioStreamPlayer.finished
		queue_free()
