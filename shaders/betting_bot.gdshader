shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D viewport_texture : source_color, filter_linear_mipmap;

void fragment() {
	ALBEDO = texture(viewport_texture, UV).rgb;
}