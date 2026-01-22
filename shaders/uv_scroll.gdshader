shader_type canvas_item;

uniform vec2 uv_offset = vec2(0.0, 0.0);
uniform vec2 uv_scale = vec2(1.0, 1.0);

void fragment() {
	vec2 uv = UV * uv_scale + uv_offset;
	COLOR = texture(TEXTURE, uv);
}
