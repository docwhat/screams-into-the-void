// Original Source:
// https://godotshaders.com/shader/starfield/
// By iVader: https://godotshaders.com/author/ivader/
// License: CC0 <https://creativecommons.org/publicdomain/zero/1.0/>
shader_type canvas_item;

const int iterations = 12;
const float formuparam2 = 0.79;
const float volsteps = 7.0;
const float stepsize = 0.290;
const float zoom = 1.0;
const float tile = 0.850;

const float brightness = 0.0015;
const float darkmatter = 0.100;
const float distfading = 0.560;
const float saturation = 0.90;


const float transverseSpeed = 1.0; //zoom;
const float cloud = 0.17;

const float time = 1.0;

float triangle(float x, float a) {
  float output2 = 2.0*abs(  3.0*  ( (x/a) - floor( (x/a) + 0.5) ) ) - 1.0;
  return output2;
}

float field(in vec3 p) {
  float strength = 7. + .03 * log(1.e-6 + fract(sin(TIME) * 373.11));
  float accum = 0.;
  float prev = 0.;
  float tw = 0.;

  for (int i = 0; i < 6; ++i) {
    float mag = dot(p, p);
    // This moves the cloud around.
    p = abs(p) / mag + vec3(-.5, -.8 + 0.1*sin(-TIME*0.1 + 2.0), -1.1+0.3*cos(time*0.3));
    float w = exp(-float(i) / 7.);
    accum += w * exp(-strength * pow(abs(mag - prev), 2.3));
    tw += w;
    prev = mag;
  }
  return max(0., 5. * accum / tw - .7);
}

const float speed = 0.0; // -0.001;

void fragment() {
  vec2 uv2 = 2. * FRAGCOORD.xy / vec2(512) - 1.;
  vec2 uvs = uv2 * vec2(512)  / 512.0;

  float formuparam = formuparam2;

  //get coords and direction
  vec2 uv = uvs;

  float a_xz = 0.9;
  float a_yz = -0.6;
  float a_xy = 0.98;

  mat2 rot_xz = mat2(vec2(cos(a_xz),sin(a_xz)),vec2(-sin(a_xz),cos(a_xz)));
  mat2 rot_yz = mat2(vec2(cos(a_yz),sin(a_yz)),vec2(-sin(a_yz),cos(a_yz)));
  mat2 rot_xy = mat2(vec2(cos(a_xy),sin(a_xy)),vec2(-sin(a_xy),cos(a_xy)));

  vec3 view_position = vec3(0.0, TIME * speed, 0.0);
  float v2 =1.0;
  vec3 dir=vec3(uv*zoom,1.);
  vec3 from=vec3(0.0, 0.0,0.0);

  from.x -= 2.0*(view_position.x-0.5);
  from.y -= 2.0*(view_position.y-0.5) - speed * TIME;

  dir.xy *= rot_xy;
  dir.xz *= rot_xz;
  dir.yz *= rot_yz;

  from.xy *= - 1.0 * rot_xy;
  from.xz *= rot_xz;
  from.yz *= rot_yz;

  //zoom
  float zooom = 0.0; // disabled
  float sampleShift = mod( zooom, stepsize );

  float zoffset = -sampleShift;
  sampleShift /= stepsize; // make from 0 to 1

  //volumetric rendering
  float s=0.24;
  float s3 = s + stepsize/2.0;
  vec3 v=vec3(0.);
  float t3 = 0.0;

  vec3 backCol2 = vec3(0.);
  for (float r=0.0; r<volsteps; r++) {
    vec3 p2 = from + s*dir;// + vec3(0.,0.,zoffset);
    vec3 p3 = from + s3*dir;// + vec3(0.,0.,zoffset);

    p2 = abs(vec3(tile)-mod(p2,vec3(tile*2.))); // tiling fold
    p3 = abs(vec3(tile)-mod(p3,vec3(tile*2.))); // tiling fold
    // #ifdef cloud
    t3 = field(p3);

    float pa, a = pa = 0.0;
    for (int i=0; i<iterations; i++) {
      p2 = abs(p2) / dot(p2, p2) - formuparam; // the magic formula
      // p2=abs(p2)/max(dot(p2,p2),0.005)-formuparam; // another interesting way to reduce noise
      float D = abs(length(p2)-pa); // absolute sum of average change
      a += i > 7 ? min( 12., D) : D;
      pa = length(p2);
    }


    float dm = max(0., darkmatter - a * a * .001); // dark matter
    a = a * a * a; // add contrast
    // brightens stuff up a bit
    float s1 = s + zoffset;
    // need closed form expression for this, now that we shift samples
    float fade = pow(distfading, max(0., float(r) - sampleShift));
    v+=fade;

    // fade out samples as they approach the camera
    if( r == 0.0 )
      fade *= (1. - (sampleShift));
    // fade in samples as they approach from the distance
    if( r == volsteps-1.0 )
      fade *= sampleShift;
    v+=vec3(s1,s1*s1,s1*s1*s1*s1)*a*brightness*fade; // coloring based on distance

    backCol2 += mix(.4, 1., v2) * vec3(1.8 * t3 * t3 * t3, 1.4 * t3 * t3, t3) * fade;
    backCol2 -= fade * 0.5;

    s+=stepsize;
    s3 += stepsize;
  }

  v = mix(vec3(length(v)), v, saturation); //color adjust

  vec4 forCol2 = vec4(v * .01, 1.0);
  backCol2 *= cloud;
  backCol2.b *= 1.8;
  backCol2.r *= 0.05;

  backCol2.b = 0.5 * mix(backCol2.g, backCol2.b, 0.8);
  backCol2.g = 0.0;
  backCol2.bg = mix(backCol2.gb, backCol2.bg, 0.5 * (cos(TIME * 0.01) + 1.0));
  COLOR = forCol2 + vec4(backCol2, 1.0);
}
