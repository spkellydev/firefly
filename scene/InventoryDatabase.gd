class_name InventoryDatabase extends Node3D

func read_ore_table():
	var ore_table = TextDatabase.load_database("res://data/schema/OreSchema.gd", "user://data/tables/ore.cfg")
	for entry in ore_table.get_array():
		# write locals
		Inventory.ore_count = entry.amount
		Inventory.ore[entry.name] = entry

# persist to filesystem
func write_ore():
	var file = FileAccess.open("user://data/tables/ore.cfg", FileAccess.WRITE)
	var table_contents = ""
	for e in Inventory.ore:
		Inventory.ore[e].update_total_ore_amount(Inventory.ore_count)
		table_contents += Inventory.ore[e].to_cfg_string()
	file.store_string(table_contents)
	file.close()
	read_ore_table()
	
func update_ore(ore_data : OreData):
	Inventory.ore_count += ore_data.amount
	Inventory.ore[ore_data.name] = ore_data
	write_ore()
