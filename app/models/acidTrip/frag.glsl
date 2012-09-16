uniform float time;
uniform vec2 resolution;
void main( void ) {
vec2 position = gl_FragCoord.xy / resolution.xy;
float red   = abs( sin( position.x * position.y + time / 0.30 ) );
float green = abs( sin( position.x * position.y + time / 0.20 ) );
float blue  = abs( sin( position.x * position.y + time / 0.10 ) );
gl_FragColor = vec4( red, green, blue, 1.0 );
}
