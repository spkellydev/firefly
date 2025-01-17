extends Control

var player_coords = Vector3(0, -1, 0)
var spacestation_coords = Vector3(0, -1, 0)
var speed = 0.0
var ore = 0

func _update_ore(amount : int):
	$Ore.text = "Ore: " + str(amount)
	ore = Inventory.ore_count

func _update_speed(amount : float):
	$Speed.text = str(amount)
	speed = amount

func follower_coords(pos : Vector3):
	$Follower.text = "x:" + str(pos.x) + " y: " + str(pos.y) + " z: " + str(pos.x)
func ownship_coords(pos : Vector3):
	$OwnShip.text = "x:" + str(pos.x) + " y: " + str(pos.y) + " z: " + str(pos.x)
	
func _update_spacestation_coords(pos: Vector3):
	$SpacestationCoords.text = "x:" + str(pos.x) + " y: " + str(pos.y) + " z: " + str(pos.x)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_coords != Inventory.own_ship:
		ownship_coords(Inventory.own_ship)
	if speed != Inventory.speed:
		_update_speed(Inventory.speed)
	if ore != Inventory.ore_count:
		_update_ore(Inventory.ore_count)
	if spacestation_coords != Globals.spacestation_coords:
		_update_spacestation_coords(Globals.spacestation_coords)
