extends Control

var ore = 0
var speed = 0.0

func _update_ore(amount : int):
	$AsteroidOre.text = "Ore: " + str(amount)
	ore = amount

func _update_speed(amount : float):
	$Speed.text = str(amount)
	speed = amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ore != Inventory.asteroid_ore:
		_update_ore(Inventory.asteroid_ore)
	if speed != Inventory.speed:
		_update_speed(Inventory.speed)
