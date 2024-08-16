shader_type canvas_item;

uniform sampler2D scroll_noise1: repeat_enable;
uniform sampler2D scroll_noise2: repeat_enable;
uniform sampler2D mask;
uniform float speed: hint_range(0.0, 2.0, 0.01) = 1.0;

void fragment() {
	COLOR.a = min(texture(mask, UV).a, COLOR.a);

	COLOR.a -= mix(
		texture(scroll_noise1, UV + TIME * speed),
		texture(scroll_noise2, UV - TIME * speed),
		0.5
	).r;
}