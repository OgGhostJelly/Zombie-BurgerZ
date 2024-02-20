shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform float top: hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
	if (UV.y < 1.0 - top) {
		COLOR = mix(COLOR, color, 0.5);
	}
}