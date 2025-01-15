@tool
class_name PlanetData extends Resource

@export var radius := 1:
	set(r):
		radius = r
		emit_signal("changed")

@export var resolution := 10:
	set(r):
		resolution = r
		emit_signal("changed")

@export var planet_noise : Array[PlanetNoise]:
	set(p):
		planet_noise = p
		for n in planet_noise:
			if n != null and !n.is_connected("changed", on_data_changed):
				n.connect("changed", on_data_changed)

@export var biomes : Array[PlanetBiome]:
	set(c):
		biomes = c
		for i in range(biomes.size()):
			if biomes[i] == null:
				biomes[i] = PlanetBiome.new()
			if biomes[i] != null and !biomes[i].is_connected("changed", on_data_changed):
				biomes[i].connect("changed", on_data_changed)

@export var biome_noise : FastNoiseLite:
	set(n):
		biome_noise = n
		emit_signal("changed")
		if biome_noise != null and !biome_noise.is_connected("changed", on_data_changed):
				biome_noise.connect("changed", on_data_changed)
@export var biome_amplitude : float:
	set(n):
		biome_amplitude = n
		emit_signal("changed")
@export var biome_offset : float:
	set(n):
		biome_offset = n
		emit_signal("changed")
@export var biome_blend : float:
	set(n):
		biome_blend = n
		emit_signal("changed")
var min_height := 99999.0
var max_height := 0.0

func point_on_planet(point_on_sphere : Vector3) -> Vector3:
	if planet_noise == null:
		return point_on_sphere
	
	var elevation = 0.0
	# mask the elevation layers
	var base_elevation = 0.0
	if planet_noise.size() > 0:
		base_elevation = (planet_noise[0].noise_map.get_noise_3dv(point_on_sphere * 100.0))
		base_elevation = (base_elevation + 1) / 2.0 * planet_noise[0].amplitude
		base_elevation = max(0, base_elevation - planet_noise[0].min_height)
	for n in planet_noise:
		var mask = 1.0
		if n.use_first_layer_as_mask:
			mask = base_elevation
		
		var level_elevation = n.noise_map.get_noise_3dv(point_on_sphere * 100.0)
		elevation = elevation + 1 / 2.0 * n.amplitude
		elevation = max(0.0, elevation - n.min_height) * mask
		elevation += level_elevation
	return point_on_sphere * radius * (elevation + 1.0)

func on_data_changed():
	emit_signal("changed")

func update_biome_texture() -> ImageTexture:
	var img_texture = ImageTexture.new()
	var dynamic_texture = Image.new()
	var height : int = biomes.size()
	
	if height > 0:
		var d : PackedByteArray = PackedByteArray()
		var w : int = biomes[0].gradient.width
		for b in biomes:
			d.append_array(b.gradient.get_image().get_data())
		dynamic_texture = Image.create_from_data(w, height, false, Image.FORMAT_RGBA8, d)
		img_texture = ImageTexture.create_from_image(dynamic_texture)

	return img_texture

func biome_percent_from_point(point_on_unit_sphere : Vector3) -> float:
	var height_percent := (point_on_unit_sphere.y + 1.0) / 2.0
	height_percent += ((biome_noise.get_noise_3dv(point_on_unit_sphere*100.0) + 1.0 / 2.0) - biome_offset) * biome_amplitude
	var biome_index : float = 0.0
	var num_biome := biomes.size()
	var blend_range = biome_blend / 2.0
	for i in range(num_biome):
		var dst : float = height_percent - biomes[i].start_height
		var l = clamp(inverse_lerp(-blend_range, blend_range, dst), 0.0, 1.0)
		var weight = l
		biome_index *= (1 - weight)
		biome_index += i * weight
	return biome_index / max(1.0, num_biome - 1)
