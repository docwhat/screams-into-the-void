shader_type canvas_item;
render_mode blend_mix, unshaded;


uniform float pixels: hint_range(1, 128, 1) = 75.0;
uniform float noise_size : hint_range(1, 20, 0.1) = 5.3;
uniform float crater_size : hint_range(0.05, 2.0, 0.05) = 0.3;
uniform vec4[3] colors : source_color;
uniform float seed: hint_range(1, 10) = 1.567;
const vec2 light_origin = vec2(0.39, 0.39);


uniform bool dissolving = false;
uniform float dissolve_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 dissolve_color : source_color = vec4(0.0, 1.02, 1.2, 1.0);
uniform float dissolve_noise_density : hint_range(1.0, 100.0, 1.0) = 60.0;
uniform float dissolve_beam_size : hint_range(0.0, 1.5, 0.1) = 0.1;

float rand(vec2 coord) {
  return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 15.5453 * seed);
}

// We are generating our own noise here. You could experiment with the 
// built in SimplexNoise or your own noise texture for other effects.
vec2 rand_v2(vec2 uv) {
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}


float dither_noise(vec2 coord){
  vec2 i = floor(coord);
  vec2 f = fract(coord);

  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));

  vec2 cubic = f * f * (3.0 - 2.0 * f);

  return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float dissolve_noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( rand_v2(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( rand_v2(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( rand_v2(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( rand_v2(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) * 0.5 + 0.5;
}

float fbm(vec2 coord){
  float value = 0.0;
  float scale = 0.5;

  for(int i = 0; i < 4 ; i++){
    value += dither_noise(coord) * scale;
    coord *= 2.0;
    scale *= 0.5;
  }
  return value;
}

bool dither(vec2 uv1, vec2 uv2) {
  return mod(uv1.x+uv2.y,2.0/pixels) <= 1.0 / pixels;
}

vec2 rotate(vec2 coord, float angle){
  coord -= 0.5;
  coord *= mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
  return coord + 0.5;
}

// by Leukbaars from https://www.shadertoy.com/view/4tK3zR
float circleNoise(vec2 uv) {
  float uv_y = floor(uv.y);
  uv.x += uv_y * 0.31;
  vec2 f = fract(uv);
  float h = rand(vec2(floor(uv.x),floor(uv_y)));
  float m = (length(f-0.25-(h*0.5)));
  float r = h*0.25;
  return m = smoothstep(r-.10*r,r,m);
}

float crater(vec2 uv) {
  float c = 1.0;
  for (int i = 0; i < 2; i++) {
    c *= circleNoise((uv / crater_size) + (float(i+1)+10.));
  }
  return 1.0 - c;
}



void fragment() {
  // Make UV 0.0 to 1.0 instead of -0.5 to 0.5
  vec2 norm_uv = UV + 0.5;

  //pixelize uv
  vec2 uv = floor(norm_uv*pixels)/pixels;

  // we use this val later to interpolate between shades
  bool dith = dither(uv, norm_uv);

  // two crater values, again one extra for the shadows
  float c1 = crater(uv) * 0.5;
  float c2 = crater(uv + length(light_origin-0.5)*0.03);

  float n = fbm(uv * noise_size);
  vec4 col = colors[1];

  float light_boundary = 0.4;
  float dark_boundary = 0.6;
  float boundary_size = 0.05;

  // noise
  if (n < light_boundary || (n < (light_boundary + boundary_size) && dith)) {
    col = colors[0];
  }
  if (n > dark_boundary || (n > (dark_boundary - boundary_size) && dith)) {
    col = colors[2];
  }

  // crater
  if (c1 > 0.4)  {
    col = colors[1];
  }
  if (c2 < c1) {
    col = colors[2];
  }

  // dissolve effect
  if (dissolving) {
    float noise = dither_noise(uv * dissolve_noise_density);

    // Interface between visible and invisible.
    float d1 = step(dissolve_progress, noise);
    float d2 = step(dissolve_progress - dissolve_beam_size, noise);

    // Add a glowing beam at the interface. 
    vec3 beam = vec3(d2 - d1) * dissolve_color.rgb;
    col.rgb += beam;

    // Fade out the whole thing as it dissolves.
    col.a *= d2;
  }
	
	COLOR = col;
}
