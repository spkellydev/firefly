extends  Node

var ore = {}
var ore_count = 0
var own_ship = Vector3.ZERO
var speed = 0.0

func _ready():
	read_ore_table()
	
func read_ore_table():
	var ore_table = TextDatabase.load_database("res://data/schema/OreSchema.gd", "user://data/tables/ore.cfg")
	for entry in ore_table.get_array():
		ore_count = entry.amount


func write_ore():
	var file = FileAccess.open("user://data/tables/ore.cfg", FileAccess.WRITE)
	var table_contents = ""
	for e in ore:
		ore[e].update_total_ore_amount(ore_count)
		table_contents += ore[e].to_cfg_string()
	file.store_string(table_contents)
	file.close()
	read_ore_table()
## Table definition
#[IronOre]
#id = 0
#name = "IronOre"
#amount = 0
#ore_type = "IRON"
func update_ore(id : int, ore_data : OreData):
	ore_count += ore_data.amount
	ore[ore_data.name] = ore_data
	write_ore()
