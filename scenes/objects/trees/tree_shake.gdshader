shader_type canvas_item;

uniform float shake_intensity = 0.0;
uniform float shake_speed = 20.0;

void vertex() {
	vec2 shake = vec2(0.0);

	if (VERTEX.y < 0.0) {
		shake = vec2(sin(TIME * shake_speed) * shake_intensity, 0.0);
	}

	VERTEX.xy += shake;
	// Called for every vertex the material is visible on.
}