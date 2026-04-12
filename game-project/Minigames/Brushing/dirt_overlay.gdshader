shader_type canvas_item;

// Dirt overlay shader — uses a mask texture to reveal the fossil underneath.
// White mask = dirt visible, black mask = fossil visible (dirt transparent).
// Adds noise-based texture to make the dirt look natural.

uniform sampler2D mask_texture : filter_nearest;
uniform vec4 dirt_color_light : source_color = vec4(0.55, 0.42, 0.25, 1.0);
uniform vec4 dirt_color_dark : source_color = vec4(0.35, 0.22, 0.12, 1.0);

// Simple hash-based noise
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	float mask_val = texture(mask_texture, UV).r;

	// Layered noise for natural dirt look
	float n = noise(UV * 8.0) * 0.5 + noise(UV * 16.0) * 0.3 + noise(UV * 32.0) * 0.2;

	// Mix between light and dark dirt colors using noise
	vec4 dirt = mix(dirt_color_dark, dirt_color_light, n);

	// Soft edge on the brush strokes
	float soft_mask = smoothstep(0.0, 0.15, mask_val);

	COLOR = dirt;
	COLOR.a = soft_mask;
}
