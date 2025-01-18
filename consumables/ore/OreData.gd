class_name OreData extends Resource

var total_ore_amount : int = 0

@export var name : String = "Empty Ore"
@export var ore_type : String = "IRON"
@export var amount : int = 1

func update_total_ore_amount(a : int):
	total_ore_amount = a

## Table definition
#[IronOre]
#id = 0
#name = "IronOre"
#amount = 0
#ore_type = "IRON"
func to_cfg_string():
	var ret_str = "["
	ret_str += name
	ret_str += "]\n"
	
	ret_str += "name = "
	ret_str += "\""
	ret_str += name
	ret_str += "\""
	ret_str += "\n"
	
	ret_str += "amount = "
	ret_str += str(total_ore_amount)
	ret_str += "\n"
	
	ret_str += "ore_type = "
	ret_str += "\""
	ret_str += ore_type
	ret_str += "\""
	ret_str += "\n"
	return ret_str
