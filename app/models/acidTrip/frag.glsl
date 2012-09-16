uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
  float t = time / 1000.0;
  vec2 p = gl_FragCoord.xy / resolution.xy;
  float i = p.x + p.y + t;
  float c = abs(sin(i));
	vec2 m = vec2(mouse.x, resolution.y - mouse.y);

	if (distance(gl_FragCoord.xy, m.xy) < 20.0 ) {
		gl_FragColor = vec4( 0.0, 1.0, 0.0, 1.0 );
  } else {
    gl_FragColor = vec4( c, c, c, 1.0 );
  }
}

//float red   = abs(sin(position.x * position.y + time / 3.0));
//float green = abs(sin(position.x * position.y + time / 2.0));
//float blue  = abs(sin(position.x * position.y + time / 1.0));
