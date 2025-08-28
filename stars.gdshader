shader_type canvas_item;
render_mode unshaded;

// The speed that the stars move towards the bottom of the screen.
uniform float speed : hint_range(0.0, 10.0, 0.001) = 0.01;
// How fast the stars dim and undim.
const float twinkle_speed = 0.2358404332;
// How many stars per fragment.
uniform float stars_ratio : hint_range(1.5, 30.0, 0.1) = 5;
// Overall brighness of all stars.
uniform float all_brightness : hint_range(0.1, 1.0, 0.01) = 1.0;

// The percentage of each color in stars, randomly distributed.
const vec3 starTint = vec3(0.4, 0.1, 0.9);

// Returns a float between 0.0 and 1.0.
float normalSin(float largeValue) {
  return sin(largeValue) / 2.0 + 0.5;
}

vec3 normalSin3(vec3 largeValues) {
  return vec3(
    normalSin(largeValues.x),
    normalSin(largeValues.y),
    normalSin(largeValues.z)
  );
}

mat2 rotate(float rads) {
  float s = sin(rads);
  float c = cos(rads);

  return mat2(vec2(c, -s), vec2(s, c));
}

float starBrightness(vec2 uv, float flare) {
  // Circle at center of star.
  float d = length(uv);
  float brightness = 0.05 / d * all_brightness;

  // Horizontal & Vertical rays.
  float rays = 1.0 - min(1.0, abs(uv.x * uv.y * 1000.0));
  brightness += rays * flare;

  // Diagonal rays.
  vec2 fortyFiveUV = uv * rotate(PI / 4.0);
  float fortyFiveRays = 1.0 - min(1.0, abs(fortyFiveUV.x * fortyFiveUV.y * 1000.0));
  brightness += fortyFiveRays * flare * 0.3;

  // Fade out within one unit to prevent incursion into neighbors.
  brightness *= smoothstep(1.0, 0.2, d) - 0.2;

  // FIXME: The halo around the stars is still falls off too suddenly, creating circles.

  return brightness;
}

// Returns a pseudo-random number from 0.0 to 1.0. It is a glorified hash function.
float random (vec2 uv) {
  // The only requirement for these numbers is that they are large enough to stir up
  // the fractional part of the number.
  return fract(sin(dot(uv.xy,
      vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 starLayer(vec2 uv) {
  vec3 color = vec3(0.0);
  vec2 repeatingUV = fract(uv) - 0.5;
  vec2 id = floor(uv);

  // We calculate the neighboring squares as well.
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 offset = vec2(float(x), float(y));
      float n = random(id + offset);
      float size = fract(n * PI);
      float flare = smoothstep(0.9, 1.0, size);

      float star = 0.0;
      vec2 starUV = repeatingUV;
      starUV -= offset;
      starUV -= vec2(n, fract(n * 23.42)) - 0.5;

      star += starBrightness(starUV, flare);

      // The vec3 is arbitrary. As long as the numbers aren't the same.
      vec3 starColor = normalSin3(vec3(0.2, 0.4, 0.7) * fract(n * 2345.2) * 123.2);
        starColor *= mix(0.4, 1.0, size); // bigger is brighter.
        starColor *= vec3(1.0 + size, 0.9, 1.0 - size); // bigger is redder, smaller is bluer.
        starColor = normalize(starColor); // re-normalize.

      // Make them twinkle!
      float twinkle = normalSin(TIME * (3.0 + twinkle_speed) * (1.0 - size) * n);

      color += star * size * starColor * twinkle;
    }
  }

  return color;
}

void fragment() {
  vec2 uv = UV;

  // Put 0,0 in center of the viewport.
  // uv -= 0.5; // Not needed in production.

  // Correct the aspect ratio.
  uv = uv / vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);

  // Keep the background moving.
  uv.y -= TIME * speed;

  // Increase the number of UV repitions per fragment.
  uv *= stars_ratio;

  vec3 color = vec3(0.0); // black

  // Front layer
  color += starLayer(uv);
  color += starLayer(uv / 2.0) * 0.2;

  // Background layer
  // color += starLayer(uv * 2.0) * 0.5;

  // color.r += uv.y;

  // color.r = sin(uv.y - distance/10.0) / 2.0 + 0.5;
  // color.g += fract(uv.y) / 4.0;

  COLOR = vec4(clamp(color, 0.0, 1.0), 1.0);
}
