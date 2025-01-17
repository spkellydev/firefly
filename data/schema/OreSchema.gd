## https://github.com/KoBeWi/Godot-Text-Database/tree/master/ExampleProject
extends TextDatabase

enum OreType { IRON, UA }

func _schema_initialize():
	add_mandatory_property("name", TYPE_STRING)
	add_mandatory_property("ore_type", TYPE_STRING)
	add_mandatory_property("amount", TYPE_INT)

func _postprocess_entry(entry: Dictionary):
	entry.ore_type = OreType[entry.ore_type]
