extends  Node

var ore = {}
var ore_count = 0
var own_ship = Vector3.ZERO
var speed = 0.0

var database = InventoryDatabase.new()

func _ready():
	database.read_ore_table()
	
func update_ore(ore_data : OreData):
	database.update_ore(ore_data)
	

