uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
  float t = time / 1000.0; // not used right now
  vec2  p = gl_FragCoord.xy / resolution.xy;
  vec2  m = vec2(mouse.x, resolution.y - mouse.y);
  float d = distance(gl_FragCoord.xy, m.xy);
  float aspect = resolution.x/resolution.y;

  if (m != vec2(0.0, 0.0) && d < 20.0) {
		gl_FragColor = vec4( vec3( 1.0, 0.5, 0.5 ), 1.0 );
	} else {
		float dx = 0.0008;
		float dy = dx * aspect;
		vec4 v0 = texture2D( backbuffer, p );
		vec4 v1 = texture2D( backbuffer, p + vec2( 0.0, dy ) );
		vec4 v2 = texture2D( backbuffer, p + vec2( dx, 0.0 ) );
		vec4 v3 = texture2D( backbuffer, p + vec2( 0.0, -dy ) );
		vec4 v4 = texture2D( backbuffer, p + vec2( -dx, 0.0 ) );
		vec4 v5 = texture2D( backbuffer, p + vec2( dx, dy ) );
		vec4 v6 = texture2D( backbuffer, p + vec2( -dx, -dy ) );
		vec4 v7 = texture2D( backbuffer, p + vec2( dx, -dy ) );
		vec4 v8 = texture2D( backbuffer, p + vec2( -dx, dy ) );

		vec4 s = v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8;

		// live cell
		if ( v0.x == 1.0 ) {
			if ( s.x < 2.0 || s.x > 3.0 )
				gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
			else
				gl_FragColor = vec4( 1.0, 0.5, 0.5, 1.0 );
		// dead cell
		} else {
			if ( s.x == 3.0 )
				gl_FragColor = vec4( 1.0, 0.5, 0.5, 1.0 );
		}
	}
}
