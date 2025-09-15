shader_type canvas_item;
render_mode blend_mix;

uniform float pixels: hint_range(1, 128, 1) = 75.0;
uniform float noise_size : hint_range(1, 20, 0.1) = 5.3;
uniform float crater_size : hint_range(0.05, 2.0, 0.05) = 0.3;
uniform vec4[3] colors : source_color;
uniform float seed: hint_range(1, 10) = 1.567;
const vec2 light_origin = vec2(0.39, 0.39);

float rand(vec2 coord) {
  return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 15.5453 * seed);
}

float noise(vec2 coord){
  vec2 i = floor(coord);
  vec2 f = fract(coord);

  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));

  vec2 cubic = f * f * (3.0 - 2.0 * f);

  return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
  float value = 0.0;
  float scale = 0.5;

  for(int i = 0; i < 4 ; i++){
    value += noise(coord) * scale;
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
  //pixelize uv
  vec2 uv = floor(UV*pixels)/pixels;

  // we use this val later to interpolate between shades
  bool dith = dither(uv, UV);

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

  COLOR = vec4(col.rgb, 1.0);
}
