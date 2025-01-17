extends MeshInstance3D
const REWARD = preload("res://consumables/ore/ore.tscn")
var count = 0
const SFX : AudioStreamWAV = preload("res://assets/sounds/impact/8bit_bomb_explosion.wav")

func hit_bullet():
	get_parent().get_node("AudioStreamPlayer").stream = SFX
	get_parent().get_node("AudioStreamPlayer").play()
	
	if has_meta("ore"):
		# hacky way to prevent multiple spawns from process call
		if count > 0:
			return
		count += 1
		var reward = REWARD.instantiate()
		reward.transform.basis = transform.basis
		get_parent().add_child(reward)
		reward.global_position = global_position
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
