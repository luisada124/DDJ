shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(0.04, 0.06, 0.12, 0.6);
uniform vec4 bottom_color : source_color = vec4(0.01, 0.01, 0.02, 0.75);
uniform float vignette_strength = 0.6;

void fragment() {
	vec2 uv = UV;
	vec4 grad = mix(top_color, bottom_color, uv.y);
	float d = distance(uv, vec2(0.5, 0.5));
	float v = smoothstep(0.45, 0.85, d) * vignette_strength;
	grad.rgb = mix(grad.rgb, grad.rgb * 0.3, v);
	COLOR = grad;
}
