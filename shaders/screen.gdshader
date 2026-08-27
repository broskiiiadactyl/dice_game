//https://godotshaders.com/shader/advance-holografic-aaa/

//note: removed glitch effect and added texture scroll

shader_type spatial;
render_mode unshaded, blend_mix;

// Grupo: Textura Base
group_uniforms base_texture;
uniform sampler2D albedo_texture : source_color;
uniform float albedo_alpha : hint_range(0.0, 1.0) = 1.0;

// Grupo: Tinte y Borde
group_uniforms tint_edge;
uniform vec4 tint_color : source_color = vec4(1.0, 0.5, 0.0, 0.5); // #FF8000
uniform vec4 edge_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // #FF0000
uniform float edge_power : hint_range(0.0, 1.0) = 0.5;
uniform float edge_size : hint_range(0.1, 5.0) = 1.0;
uniform float edge_intensity : hint_range(0.0, 2.0) = 0.8;

// Grupo: Scanlines
group_uniforms scanlines;
uniform sampler2D scanline_texture;
uniform vec4 scanline_tint : source_color = vec4(1.0, 0.5, 0.0, 1.0); // #FF8000
uniform float scanline_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float scanline_density : hint_range(0.0, 10.0) = 5.0;
uniform float scanline_thickness : hint_range(0.1, 3.0) = 1.0;
uniform float scanline_spacing : hint_range(0.5, 4.0) = 1.0;
uniform float scanline_angle : hint_range(0.0, 6.283) = 0.0;
uniform float scanline_speed = 0.2;


float random(float seed) {
    return fract(sin(seed * 12345.678) * 43758.5453);
}

varying float enable_shift;

void vertex() {
	vec2 new_uv = UV - vec2(0.0, 0.1 * TIME);
	
	UV = new_uv;
}

void fragment() {
    float adjusted_time = mod(TIME, 5.0);
    vec2 fixed_uv = UV;

    // RGB split glitch (nuevo)
    vec4 color;

    color = texture(albedo_texture, fixed_uv);

    color.a *= albedo_alpha;
    vec4 tinted = mix(color, color * tint_color, tint_color.a);

    float edge = 1.0 - dot(NORMAL, VIEW);
    edge = pow(edge, mix(8.0, 2.0, edge_power));
    edge = smoothstep(0.5 - edge_size * 0.1, 0.5 + edge_size * 0.1, edge);
    vec4 edge_effect = edge * edge_intensity * edge_color;

    vec4 scan = vec4(0.0);
    if (scanline_density > 0.001) {
        vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE;
        vec2 dir = vec2(cos(scanline_angle), sin(scanline_angle));
        float scan_pos = (UV.x * dir.x + UV.y * dir.y);
        float spacing = mix(50.0, 10.0, scanline_density / 10.0) * scanline_spacing;
        float time_offset = TIME * scanline_speed;
        float line = fract(scan_pos * spacing + time_offset);
        line = smoothstep(
            0.5 - 0.1 * scanline_thickness,
            0.5 + 0.1 * scanline_thickness,
            abs(line - 0.5)
        );
        scan = vec4(scanline_tint.rgb * line * scanline_intensity, line * scanline_tint.a);
    }

    ALBEDO = tinted.rgb + edge_effect.rgb + scan.rgb;
    ALPHA = max(tinted.a, max(edge_effect.a, scan.a));
}
