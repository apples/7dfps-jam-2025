shader_type spatial;
render_mode blend_mix,cull_back,diffuse_burley,specular_schlick_ggx
,depth_draw_opaque
;
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform int depth_min_layers = 8;
uniform int depth_max_layers = 16;
uniform vec2 depth_flip = vec2(1.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float dot2(vec2 x) {
	return dot(x, x);
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5);
}
vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5);
}
vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5);
}
float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}
float param_rndi(float minimum, float maximum, float seed) {
	return floor(param_rnd(minimum, maximum + 1.0, seed));
}
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
const vec4 p_o523264598952_albedo_color = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
const float p_o523264598952_metallic = 0.000000000;
const float p_o523264598952_roughness = 1.000000000;
const float p_o523264598952_emission_energy = 1.000000000;
const float p_o523264598952_normal = 1.000000000;
const float p_o523264598952_ao = 1.000000000;
const float p_o523264598952_depth_scale = 0.500000000;
const float p_o57538200482282_translate_x = 0.000000000;
const float p_o57538200482282_translate_y = 0.000000000;
const float p_o57538200482282_rotate = 90.000000000;
const float p_o57538200482282_scale_x = -1.000000000;
const float p_o57538200482282_scale_y = 1.000000000;
const float p_o35770417030872_amount1 = 1.000000000;
const float p_o48276590038276_default_in1 = 0.000000000;
const float p_o48276590038276_default_in2 = 0.000000000;
const float p_o36851490502063_repeat = 1.000000000;
const float p_o36851490502063_rotate = 90.000000000;
const float p_o36851490502063_gradient_pos[4] = float[]( 0.000000000, 0.100964494, 0.896766007, 1.000000000 );
const vec4 p_o36851490502063_gradient_col[4] = vec4[]( vec4(0.000000000, 0.000000000, 0.000000000, 0.000000000), vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000), vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000), vec4(0.000000000, 0.000000000, 0.000000000, 0.000000000) );
const float p_o23887333042820_gradient_pos[2] = float[]( 0.499377191, 1.000000000 );
const vec4 p_o23887333042820_gradient_col[2] = vec4[]( vec4(0.000000000, 0.000000000, 0.000000000, 0.000000000), vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000) );
uniform sampler2D texture_1;
const float texture_1_size = 256.000000000;
const float p_o33425146781730_translate_y = 0.000000000;
const float p_o28427432241784_gradient_pos[2] = float[]( 0.000000000, 1.000000000 );
const vec4 p_o28427432241784_gradient_col[2] = vec4[]( vec4(1.000000000, 1.000000000, 1.000000000, 0.000000000), vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000) );
uniform sampler2D texture_2;
const float texture_2_size = 256.000000000;
// #globals: decompose_4 (o51615591576264)
// #globals: transform2 (o57538200482282)
vec2 transform2_clamp(vec2 uv) {
	return clamp(uv, vec2(0.0), vec2(1.0));
}
vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {
 	vec2 rv;
	uv -= translate;
	uv -= vec2(0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += vec2(0.5);
	return rv;
}
// #globals: blend
vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1 + (1.0-opacity)*c2;
}
vec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	if (rand(uv) < opacity) {
		return c1;
	} else {
		return c2;
	}
}
vec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1*c2 + (1.0-opacity)*c2;
}
vec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;
}
float blend_overlay_f(float c1, float c2) {
	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));
}
vec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;
}
float blend_soft_light_f(float c1, float c2) {
	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);
}
vec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_burn_f(float c1, float c2) {
	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);
}
vec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_dodge_f(float c1, float c2) {
	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);
}
vec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*max(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*min(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;
}
vec3 blend_additive(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + c1 * oppacity;
}
vec3 blend_addsub(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + (c1 - .5) * 2.0 * oppacity;
}
// #globals: adjust_hsv
vec3 rgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv_to_rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// #globals: blend2 (o35770417030872)
float blend_linear_light_f(float c1, float c2) {
	return (c1 + 2.0 * c2) - 1.0;
}
vec3 blend_linear_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
return opacity*vec3(blend_linear_light_f(c1.x, c2.x), blend_linear_light_f(c1.y, c2.y), blend_linear_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_vivid_light_f(float c1, float c2) {
	return (c1 < 0.5) ? 1.0 - (1.0 - c2) / (2.0 * c1) : c2 / (2.0 * (1.0 - c1));
}
vec3 blend_vivid_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_vivid_light_f(c1.x, c2.x), blend_vivid_light_f(c1.y, c2.y), blend_vivid_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_pin_light_f( float c1, float c2) {
	return (2.0 * c1 - 1.0 > c2) ? 2.0 * c1 - 1.0 : ((c1 < 0.5 * c2) ? 2.0 * c1 : c2);
}
vec3 blend_pin_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_pin_light_f(c1.x, c2.x), blend_pin_light_f(c1.y, c2.y), blend_pin_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_hard_mix_f(float c1, float c2) {
	return floor(c1 + c2);
}
vec3 blend_hard_mix(vec2 uv, vec3 c1, vec3 c2, float opacity) {
		return opacity*vec3(blend_hard_mix_f(c1.x, c2.x), blend_hard_mix_f(c1.y, c2.y), blend_hard_mix_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_exclusion_f(float c1, float c2) {
	return c1 + c2 - 2.0 * c1 * c2;
}
vec3 blend_exclusion(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_exclusion_f(c1.x, c2.x), blend_exclusion_f(c1.y, c2.y), blend_exclusion_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hue(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	vec3 outcol = c2;
	vec3 hsv, hsv2, tmp;
	hsv2 = rgb_to_hsv(c1);
	if (hsv2.y != 0.0) {
		hsv = rgb_to_hsv(outcol);
		hsv.x = hsv2.x;
		tmp = hsv_to_rgb(hsv);
		outcol = mix(outcol, tmp, opacity);
	}
	return outcol;
}
vec3 blend_saturation(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 outcol = c2;
	vec3 hsv, hsv2;
	hsv = rgb_to_hsv(outcol);
	if (hsv.y != 0.0) {
		hsv2 = rgb_to_hsv(c1);
		hsv.y = facm * hsv.y + opacity * hsv2.y;
		outcol = hsv_to_rgb(hsv);
	}
	return outcol;
}
vec3 blend_color(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 outcol = c2;
	vec3 hsv, hsv2, tmp;
	hsv2 = rgb_to_hsv(c1);
	if (hsv2.y != 0.0) {
		hsv = rgb_to_hsv(outcol);
		hsv.x = hsv2.x;
		hsv.y = hsv2.y;
		tmp = hsv_to_rgb(hsv);
		outcol = mix(outcol, tmp, opacity);
	}
	return outcol;
}
vec3 blend_value(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 hsv, hsv2;
	hsv = rgb_to_hsv(c2);
	hsv2 = rgb_to_hsv(c1);
	hsv.z = facm * hsv.z + opacity * hsv2.z;
	return hsv_to_rgb(hsv);
}
// #globals: math (o48276590038276)
float pingpong(float a, float b)
{
  return (b != 0.0) ? abs(fract((a - b) / (b * 2.0)) * b * 2.0 - b) : 0.0;
}
vec4 o36851490502063_gradient_gradient_fct(float x) {
  if (x < p_o36851490502063_gradient_pos[0]) {
    return p_o36851490502063_gradient_col[0];
  } else if (x < p_o36851490502063_gradient_pos[1]) {
    return mix(p_o36851490502063_gradient_col[0], p_o36851490502063_gradient_col[1], ((x-p_o36851490502063_gradient_pos[0])/(p_o36851490502063_gradient_pos[1]-p_o36851490502063_gradient_pos[0])));
  } else if (x < p_o36851490502063_gradient_pos[2]) {
    return mix(p_o36851490502063_gradient_col[1], p_o36851490502063_gradient_col[2], ((x-p_o36851490502063_gradient_pos[1])/(p_o36851490502063_gradient_pos[2]-p_o36851490502063_gradient_pos[1])));
  } else if (x < p_o36851490502063_gradient_pos[3]) {
    return mix(p_o36851490502063_gradient_col[2], p_o36851490502063_gradient_col[3], ((x-p_o36851490502063_gradient_pos[2])/(p_o36851490502063_gradient_pos[3]-p_o36851490502063_gradient_pos[2])));
  }
  return p_o36851490502063_gradient_col[3];
}
vec4 o23887333042820_gradient_gradient_fct(float x) {
  if (x < p_o23887333042820_gradient_pos[0]) {
    return p_o23887333042820_gradient_col[0];
  } else if (x < p_o23887333042820_gradient_pos[1]) {
    return mix(p_o23887333042820_gradient_col[0], p_o23887333042820_gradient_col[1], ((x-p_o23887333042820_gradient_pos[0])/(p_o23887333042820_gradient_pos[1]-p_o23887333042820_gradient_pos[0])));
  }
  return p_o23887333042820_gradient_col[1];
}
vec4 o28427432241784_gradient_gradient_fct(float x) {
  if (x < p_o28427432241784_gradient_pos[0]) {
    return p_o28427432241784_gradient_col[0];
  } else if (x < p_o28427432241784_gradient_pos[1]) {
    return mix(p_o28427432241784_gradient_col[0], p_o28427432241784_gradient_col[1], ((x-p_o28427432241784_gradient_pos[0])/(p_o28427432241784_gradient_pos[1]-p_o28427432241784_gradient_pos[0])));
  }
  return p_o28427432241784_gradient_col[1];
}
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);

// #code: gradient (o36851490502063)
float o36851490502063_0_r = 0.5+(cos(p_o36851490502063_rotate*0.01745329251)*((transform2_clamp(transform2((uv), vec2(p_o57538200482282_translate_x*(2.0*1.0-1.0), p_o57538200482282_translate_y*(2.0*1.0-1.0)), p_o57538200482282_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o57538200482282_scale_x*(2.0*1.0-1.0), p_o57538200482282_scale_y*(2.0*1.0-1.0))))).x-0.5)+sin(p_o36851490502063_rotate*0.01745329251)*((transform2_clamp(transform2((uv), vec2(p_o57538200482282_translate_x*(2.0*1.0-1.0), p_o57538200482282_translate_y*(2.0*1.0-1.0)), p_o57538200482282_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o57538200482282_scale_x*(2.0*1.0-1.0), p_o57538200482282_scale_y*(2.0*1.0-1.0))))).y-0.5))/(cos(abs(mod(p_o36851490502063_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
// #output0: gradient (o36851490502063)
vec4 o36851490502063_0_1_rgba = o36851490502063_gradient_gradient_fct(fract(o36851490502063_0_r*p_o36851490502063_repeat));

// #output3: decompose_3 (o48050449951304)
float o48050449951304_3_1_f = o36851490502063_0_1_rgba.a;
float o68605442012655_0 = textureLod(texture_1, fract(((transform2_clamp(transform2((uv), vec2(p_o57538200482282_translate_x*(2.0*1.0-1.0), p_o57538200482282_translate_y*(2.0*1.0-1.0)), p_o57538200482282_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o57538200482282_scale_x*(2.0*1.0-1.0), p_o57538200482282_scale_y*(2.0*1.0-1.0)))))-vec2((-elapsed_time), (-elapsed_time)))), 0.0).r;

// #output0: translate_3 (o65391883728810)
vec4 o65391883728810_0_1_rgba = vec4(vec3(o68605442012655_0), 1.0);

// #output0: colorize (o23887333042820)
vec4 o23887333042820_0_1_rgba = o23887333042820_gradient_gradient_fct((dot((o65391883728810_0_1_rgba).rgb, vec3(1.0))/3.0));

// #output3: decompose_2 (o46528605468017)
float o46528605468017_3_1_f = o23887333042820_0_1_rgba.a;

// #code: math (o48276590038276)
float o48276590038276_0_clamp_false = o46528605468017_3_1_f*o48050449951304_3_1_f;
float o48276590038276_0_clamp_true = clamp(o48276590038276_0_clamp_false, 0.0, 1.0);
// #output0: math (o48276590038276)
float o48276590038276_0_1_f = o48276590038276_0_clamp_false;

// #output2: decompose_2 (o46528605468017)
float o46528605468017_2_2_f = o23887333042820_0_1_rgba.b;

// #output1: decompose_2 (o46528605468017)
float o46528605468017_1_3_f = o23887333042820_0_1_rgba.g;

// #output0: decompose_2 (o46528605468017)
float o46528605468017_0_4_f = o23887333042820_0_1_rgba.r;

// #output0: combine (o46786488052570)
vec4 o46786488052570_0_1_rgba = vec4(o46528605468017_0_4_f, o46528605468017_1_3_f, o46528605468017_2_2_f, o48276590038276_0_1_f);
vec4 o59481740293116_0 = textureLod(texture_2, fract(((transform2_clamp(transform2((uv), vec2(p_o57538200482282_translate_x*(2.0*1.0-1.0), p_o57538200482282_translate_y*(2.0*1.0-1.0)), p_o57538200482282_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o57538200482282_scale_x*(2.0*1.0-1.0), p_o57538200482282_scale_y*(2.0*1.0-1.0)))))-vec2((elapsed_time), p_o33425146781730_translate_y))), 0.0);

// #output0: colorize_2 (o28427432241784)
vec4 o28427432241784_0_1_rgba = o28427432241784_gradient_gradient_fct((dot((o59481740293116_0).rgb, vec3(1.0))/3.0));

// #output0: translate (o33425146781730)
vec4 o33425146781730_0_1_rgba = o28427432241784_0_1_rgba;

// #code: blend2 (o35770417030872)
vec4 o35770417030872_0_b = o33425146781730_0_1_rgba;
vec4 o35770417030872_0_l;
float o35770417030872_0_a;

o35770417030872_0_l = o46786488052570_0_1_rgba;
o35770417030872_0_a = p_o35770417030872_amount1*1.0;
o35770417030872_0_b = vec4(blend_overlay((transform2_clamp(transform2((uv), vec2(p_o57538200482282_translate_x*(2.0*1.0-1.0), p_o57538200482282_translate_y*(2.0*1.0-1.0)), p_o57538200482282_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o57538200482282_scale_x*(2.0*1.0-1.0), p_o57538200482282_scale_y*(2.0*1.0-1.0))))), o35770417030872_0_l.rgb, o35770417030872_0_b.rgb, o35770417030872_0_a*o35770417030872_0_l.a), min(1.0, o35770417030872_0_b.a+o35770417030872_0_a*o35770417030872_0_l.a));
// #output0: blend2 (o35770417030872)
vec4 o35770417030872_0_1_rgba = o35770417030872_0_b;

// #output0: transform2 (o57538200482282)
vec4 o57538200482282_0_1_rgba = o35770417030872_0_1_rgba;

// #output3: decompose_4 (o51615591576264)
float o51615591576264_3_1_f = o57538200482282_0_1_rgba.a;

// #output2: decompose_4 (o51615591576264)
float o51615591576264_2_2_f = o57538200482282_0_1_rgba.b;

// #output1: decompose_4 (o51615591576264)
float o51615591576264_1_3_f = o57538200482282_0_1_rgba.g;

// #output0: decompose_4 (o51615591576264)
float o51615591576264_0_4_f = o57538200482282_0_1_rgba.r;

// #output0: combine_2 (o51732176451136)
vec4 o51732176451136_0_1_rgba = vec4(o51615591576264_0_4_f, o51615591576264_1_3_f, o51615591576264_2_2_f, 1.0);

	vec3 albedo_tex = ((o51732176451136_0_1_rgba).rgb).rgb;
	albedo_tex = mix(pow((albedo_tex + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex * (1.0 / 12.92),lessThan(albedo_tex,vec3(0.04045)));
	ALBEDO = albedo_tex*p_o523264598952_albedo_color.rgb;
	METALLIC = 1.0*p_o523264598952_metallic;
	ROUGHNESS = 1.0*p_o523264598952_roughness;
	NORMAL = vec3(0.5);
	EMISSION = vec3(0.0)*p_o523264598952_emission_energy;
	ALPHA = o51615591576264_3_1_f;
}
