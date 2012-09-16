uniform float time;
uniform vec2 resolution;

void main( void ) {
  vec2 position = - 1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  float red   = abs(sin(position.x * position.y + time / 3.0));
  float green = abs(sin(position.x * position.y + time / 2.0));
  float blue  = abs(sin(position.x * position.y + time / 1.0));
  gl_FragColor = vec4( red, green, blue, 1.0 );
}
