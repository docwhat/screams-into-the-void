/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/teleport-effect

This shader is under CC0 license. Feel free to use, improve and
change this shader according to your needs and consider sharing
the modified result on godotshaders.com.
*/

shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);
uniform float noise_density = 60;
uniform float beam_size : hint_range(0.01, 0.15);
uniform float rotation : hint_range(-3.14, 3.14) = 0.0;
uniform vec4 color : source_color = vec4(0.0, 1.02, 1.2, 1.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// We are generating our own noise here. You could experiment with the
// built in SimplexNoise or your own noise texture for other effects.
vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = clamp(smoothstep(0.0, 2.0, uv_fract), 0.0, 1.0);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) * 0.5 + 0.5;
}

// Create a 2D rotation matrix.
//
// Usage:
//   vec2 rotatedUV = rotate(rads) * uv;
mat2 rotate(float rads) {
  float s = sin(rads);
  float c = cos(rads);

  return mat2(vec2(c, -s), vec2(s, c));
}

void fragment()
{
    vec4 tex = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (tex.a > 0.0001) {
		tex.rgb /= tex.a;
	}

    // Center the UV coordinates and apply rotation.
    vec2 uv = (UV - vec2(0.5)) * rotate(rotation) + vec2(0.5);

	float noise = noise(uv * noise_density) * uv.y;
	
	float beam_start = step(progress, noise);
	float beam_stop = step(progress - beam_size, noise);

	vec3 beam = vec3(beam_stop - beam_start) * color.rgb;

	tex.rgb += beam;
	tex.a *= beam_stop;
	
	COLOR = clamp(tex, 0.0, 1.0);
}

// shader_type canvas_item;

// uniform float dissolve_progress : hint_range(0.0, 1.0) = 0.0;
// uniform float particle_size : hint_range(0.5, 8.0) = 2.0;
// uniform vec4 particle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// // Simple 2D hash noise
// float hash(vec2 p) {
//     return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
// }

// void fragment() {
//     // Generate noise for dissolve mask
//     float noise = hash(UV);

//     // Dissolve threshold
//     if (noise < dissolve_progress) {
//         discard;
//     }

//     // Particle effect: quantize UV to create blocky "particles"
//     vec2 particle_uv = floor(UV * particle_size) / particle_size;
//     float particle_noise = hash(particle_uv);

//     // Animate particles: offset based on dissolve_progress
//     float offset = (dissolve_progress - noise) * 0.2;
//     vec2 animated_uv = particle_uv + vec2(offset, offset);

//     // Sample the original texture at the animated UV
//     vec4 tex_color = texture(TEXTURE, animated_uv);

//     // Blend with particle color as it dissolves
//     float blend = smoothstep(dissolve_progress, dissolve_progress + 0.1, noise);
//     COLOR = mix(particle_color, tex_color, blend) * tex_color.a;
// }