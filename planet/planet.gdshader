shader_type spatial;

uniform float min_height;
uniform float max_height;
uniform sampler2D height_color;

varying float height;

void vertex() {
	// Called for every vertex the material is visible on.
	// center of the planet is the origin of the mesh
	// length of the vertex in local space
	height = length(VERTEX);
}

void fragment() {
	// Called for every pixel the material is visible on.
	// linear interpolation of the height
	float t = height / (max_height - min_height) - (min_height / (max_height - min_height));
	vec3 color = texture(height_color, vec2(t, UV.y)).rgb;
	ALBEDO = color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
