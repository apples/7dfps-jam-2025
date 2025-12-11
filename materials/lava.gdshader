shader_type spatial;

render_mode unshaded, blend_mix;

uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
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
const float p_o20265366988770_gradient_pos[2] = float[]( 0.000000000, 1.000000000 );
const vec4 p_o20265366988770_gradient_col[2] = vec4[]( vec4(1.000000000, 0.117187500, 0.000000000, 1.000000000), vec4(1.000000000, 1.000000000, 0.000000000, 1.000000000) );
const float p_o10449185679556_amount = 0.595000000;
const float p_o10449185679556_eps = 0.085000000;
const float p_o34951504339965_translate_x = 0.000000000;
const float p_o38023714579549_translate_x = 0.500000000;
const float p_o38023714579549_translate_y = 0.500000000;
const float p_o38023714579549_rotate = 0.000000000;
const float p_o38023714579549_scale_x = 1.000000000;
const float p_o38023714579549_scale_y = 1.000000000;
const float seed_o38023731356900 = 1093.000000000;
const float p_o38023731356900_scale_x = 4.000000000;
const float p_o38023731356900_scale_y = 4.000000000;
const float p_o38023731356900_iterations = 3.000000000;
const float p_o38023731356900_persistence = 0.500000000;
const float p_o32444099078523_translate_y = 0.000000000;
const float seed_o921790587799 = 0.906586230;
const float p_o921790587799_scale_x = 16.000000000;
const float p_o921790587799_scale_y = 16.000000000;
const float p_o921790587799_stretch_x = 1.000000000;
const float p_o921790587799_stretch_y = 1.000000000;
const float p_o921790587799_intensity = 1.000000000;
const float p_o921790587799_randomness = 1.000000000;
// #globals: colorize (o20265366988770)
// #globals: graph/transform (o38023714579549)
vec2 transform(vec2 uv, vec2 translate, float rotate, vec2 scale, bool repeat) {
 	vec2 rv;
	uv -= translate;
	uv -= vec2(0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += vec2(0.5);
	if (repeat) {
		return fract(rv);
	} else {
		return clamp(rv, vec2(0.0), vec2(1.0));
	}	
}
// #globals: graph/perlin (o38023731356900)
float perlin(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
	float rv = 0.0;
	float coef = 1.0;
	float acc = 0.0;
	for (int i = 0; i < iterations; ++i) {
		vec2 step = vec2(1.0)/size;
		vec2 xy = floor(uv*size);
		float f0 = rand(seed2+mod(xy, size));
		float f1 = rand(seed2+mod(xy+vec2(1.0, 0.0), size));
		float f2 = rand(seed2+mod(xy+vec2(0.0, 1.0), size));
		float f3 = rand(seed2+mod(xy+vec2(1.0, 1.0), size));
		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));
		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;
	}
	
	return rv / acc;
}
// #globals: voronoi2 (o921790587799)
// Based on https://www.shadertoy.com/view/ldl3W8
// The MIT License
// Copyright © 2013 Inigo Quilez
vec3 iq_voronoi(vec2 x, vec2 size, vec2 stretch, float randomness, vec2 seed) {
	vec2 n = floor(x);
	vec2 f = fract(x);
	vec2 mg, mr, mc;
	float md = 8.0;
	for (int j=-1; j<=1; j++)
	for (int i=-1; i<=1; i++) {
		vec2 g = vec2(float(i),float(j));
		vec2 o = randomness*rand2(seed + mod(n + g + size, size));
		vec2 c = g + o;
		vec2 r = c - f;
		vec2 rr = r*stretch;
		float d = dot(rr,rr);
		if (d<md) {
			mc = c;
			md = d;
			mr = r;
			mg = g;
		}
	}
	md = 8.0;
	for (int j=-2; j<=2; j++)
	for (int i=-2; i<=2; i++) {
		vec2 g = mg + vec2(float(i),float(j));
		vec2 o = randomness*rand2(seed + mod(n + g + size, size));
		vec2 r = g + o - f;
		vec2 rr = (mr-r)*stretch;
		if (dot(rr,rr)>0.00001)
	   		md = min(md, dot(0.5*(mr+r)*stretch, normalize((r-mr)*stretch)));
	}
	return vec3(md, mc+n);
}
vec4 voronoi(vec2 uv, vec2 size, vec2 stretch, float intensity, float randomness, float seed) {
	uv *= size;
	vec3 v = iq_voronoi(uv, size, stretch, randomness, rand2(vec2(seed, 1.0-seed)));
	return vec4(v.yz, intensity*length((uv-v.yz)*stretch), v.x);
}
vec4 o20265366988770_gradient_gradient_fct(float x) {
  if (x < p_o20265366988770_gradient_pos[0]) {
    return p_o20265366988770_gradient_col[0];
  } else if (x < p_o20265366988770_gradient_pos[1]) {
    return mix(p_o20265366988770_gradient_col[0], p_o20265366988770_gradient_col[1], ((x-p_o20265366988770_gradient_pos[0])/(p_o20265366988770_gradient_pos[1]-p_o20265366988770_gradient_pos[0])));
  }
  return p_o20265366988770_gradient_col[1];
}
float o10449185679556_input_d(vec2 uv, float _seed_variation_) {
// #output0: graph/perlin (o38023731356900)
float o38023731356900_0_1_f = perlin((uv-vec2(p_o34951504339965_translate_x, (elapsed_time/8.0))), vec2(p_o38023731356900_scale_x, p_o38023731356900_scale_y), int(p_o38023731356900_iterations), p_o38023731356900_persistence, (seed_o38023731356900+fract(_seed_variation_)));
// #output0: graph/perlin (o38023731356900)
float o38023731356900_0_3_f = perlin((transform((uv-vec2(p_o34951504339965_translate_x, (elapsed_time/8.0))), vec2(p_o38023714579549_translate_x*(2.0*o38023731356900_0_1_f-1.0), p_o38023714579549_translate_y*(2.0*o38023731356900_0_1_f-1.0)), p_o38023714579549_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o38023714579549_scale_x*(2.0*1.0-1.0), p_o38023714579549_scale_y*(2.0*1.0-1.0)), true)), vec2(p_o38023731356900_scale_x, p_o38023731356900_scale_y), int(p_o38023731356900_iterations), p_o38023731356900_persistence, (seed_o38023731356900+fract(_seed_variation_)));
// #output0: graph/transform (o38023714579549)
vec4 o38023714579549_0_1_rgba = vec4(vec3(o38023731356900_0_3_f), 1.0);
// #output0: translate_2 (o34951504339965)
vec4 o34951504339965_0_1_rgba = o38023714579549_0_1_rgba;
return (dot((o34951504339965_0_1_rgba).rgb, vec3(1.0))/3.0);
}
// #instance: warp (o10449185679556)
vec2 o10449185679556_slope(vec2 uv, float epsilon, float _seed_variation_) {
	return vec2(o10449185679556_input_d((fract(uv+vec2(epsilon, 0.0))), _seed_variation_)-o10449185679556_input_d((fract(uv-vec2(epsilon, 0.0))), _seed_variation_), o10449185679556_input_d((fract(uv+vec2(0.0, epsilon))), _seed_variation_)-o10449185679556_input_d((fract(uv-vec2(0.0, epsilon))), _seed_variation_));
}
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);

// #code: warp (o10449185679556)
vec2 o10449185679556_0_slope = o10449185679556_slope((uv), p_o10449185679556_eps, _seed_variation_);
vec2 o10449185679556_0_warp = o10449185679556_0_slope*(1.0-o10449185679556_input_d((uv), _seed_variation_));
// #code: voronoi2 (o921790587799)
vec4 o921790587799_0_xyzw = voronoi((((uv)+p_o10449185679556_amount*o10449185679556_0_warp)-vec2((elapsed_time/16.0), p_o32444099078523_translate_y)), vec2(p_o921790587799_scale_x, p_o921790587799_scale_y), vec2(p_o921790587799_stretch_y, p_o921790587799_stretch_x), p_o921790587799_intensity, p_o921790587799_randomness, (seed_o921790587799+fract(_seed_variation_)));
// #output0: voronoi2 (o921790587799)
float o921790587799_0_1_f = o921790587799_0_xyzw.z;

// #output0: translate (o32444099078523)
vec4 o32444099078523_0_1_rgba = vec4(vec3(o921790587799_0_1_f), 1.0);

// #output0: warp (o10449185679556)
vec4 o10449185679556_0_1_rgba = o32444099078523_0_1_rgba;

// #output0: colorize (o20265366988770)
vec4 o20265366988770_0_1_rgba = o20265366988770_gradient_gradient_fct((dot((o10449185679556_0_1_rgba).rgb, vec3(1.0))/3.0));

	vec4 color_tex = o20265366988770_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	ALBEDO = color_tex.rgb;
	//ALPHA = color_tex.a;
}



