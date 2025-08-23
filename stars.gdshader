shader_type canvas_item;
render_mode unshaded, world_vertex_coords;

uniform bool showGrid;
uniform float time = 0.0;

// The percentage of each color in stars, randomly distributed.
const vec3 starTint = vec3(0.4, 0.1, 0.9);

mat2 rotate(float rads) {
  float s = sin(rads);
  float c = cos(rads);

  return mat2(vec2(c, -s), vec2(s, c));
}

float starBrightness(vec2 uv, float flare) {
  //     // Circle at center of star.
  float d = length(uv);
  float brightness = 0.05 / d;

  // Horizontal & Vertical rays.
  float rays = 1.0 - min(1.0, abs(uv.x * uv.y * 1000.0));
  brightness += rays * flare;

  // Diagonal rays.
  vec2 fortyFiveUV = uv * rotate(PI / 4.0);
  float fortyFiveRays = 1.0 - min(1.0, abs(fortyFiveUV.x * fortyFiveUV.y * 1000.0));
  brightness += fortyFiveRays * flare * 0.3;

  // Fade out within one unit to prevent incursion into neighbors.
  brightness *= smoothstep(1.0, 0.2, d);

  return brightness;
}

// A hash that's only good for things like graphics.
// Returns a number from 0.0 to 1.0.
float hash21(vec2 p) {
  // The only requirement for these numbers are that they are large enough to
  // interesting remainders.
  const float largeArbitraryNumber1 = 1972.1974;
  const float largeArbitraryNumber2 = 3141.5926;
  const float arbitraryNumber = 92.81;

  vec2 n = p;
  n += fract(n * vec2(largeArbitraryNumber1, largeArbitraryNumber2));
  n += dot(n, n + arbitraryNumber);

  return fract(n.x * n.y);
}

vec3 starLayer(vec2 uv) {
  vec3 color = vec3(0.0);

  vec2 repeatingUV = fract(uv) - 0.5;
  vec2 id = floor(uv);

  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 offset = vec2(float(x), float(y));
      float n = hash21(id + offset);
      float size = fract(n * 345.32);

      float star = starBrightness(repeatingUV - offset - vec2(n, fract(34.0 * n)) + 0.5, smoothstep(0.9, 1.0, size));

      const float arbitraryLargeNumber1 = 4345.2;
      vec3 starColor = sin(starTint * fract(n * arbitraryLargeNumber1) * arbitraryLargeNumber1) * 0.5 + 0.5;

      // Make bigger stars bluer and less red and green.
      starColor *= vec3(1.0 - size * 0.5, 1.0 - size * 0.7, 1.0 - size * 0.2);

      // Make them twinkle!
      starColor *= sin(TIME + n * 2.0 * PI) / 4.0 + 0.5;

      color += star * size * starColor;

    }
  }

  // Creates a grid. Useful for debugging.
  if (showGrid && (repeatingUV.x > 0.49 || repeatingUV.y > 0.49)) color.r = 1.0;

  return color;
}

void fragment() {
  //vec2 uv = UV.xy;

  // Put 0,0 in center of screen.
  // uv = uv - 0.5 * iResolution.xy;
  // uv = uv - 0.5 * VIEWPORT_SIZE.xy;

  // Correct aspect ratio.
  // uv = uv / VIEWPORT_SIZE.y;

  // Increase the (virtual) resolution.
  //uv *= 5.0;

  // vec2 uv = (SCREEN_UV - 0.5) / vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);
  vec2 uv = SCREEN_UV;

  // Put 0,0 in center of the viewport.
  uv -= 0.5;

  // Correct the aspect ratio.
  uv = uv / vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);

  // Increase the effective resolution.
  uv *= 5.0;

  vec3 color = vec3(0.0); // black

  // Front layer
  color += starLayer(uv);

  // Background layer
  color += starLayer(uv * 2.0) * 0.5;

  COLOR = vec4(color, 1.0);
}
