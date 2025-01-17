class_name InventoryDatabase extends Node3D


func get_entry(s : String):
	var d = TextDatabase.new()
	d.load_from_path("res://data/tables/inventory.cfg")
	var data = d.get_array()
	for a in data:
		if a.name == s:
			return a
