shader_type spatial;
render_mode unshaded, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo;
uniform sampler2D texture_albedo: source_color, filter_linear_mipmap, repeat_enable;

void vertex() {
	UV = VERTEX.xz;
}

void fragment() {
	vec2 uv = vec2(pow(length(UV) / 0.5, 0.75) - TIME * 0.3, atan(UV.y, UV.x) / TAU);
	ALBEDO = textureGrad(texture_albedo, uv, dFdx(UV), dFdy(UV)).rgb;
	METALLIC = 0.5;
	SPECULAR = 0.8;
	ROUGHNESS = 0.5;
}
