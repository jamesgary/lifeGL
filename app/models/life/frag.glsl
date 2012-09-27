uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec4 cellColor;

uniform float minLiveNeighborRule;
uniform float maxLiveNeighborRule;
uniform float minDeadNeighborRule;
uniform float maxDeadNeighborRule;

void main( void ) {
  float t = time / 1000.0; // not used right now
  vec2  p = gl_FragCoord.xy / resolution.xy;
  vec2  m = vec2(mouse.x, resolution.y - mouse.y);
  float d = distance(gl_FragCoord.xy, m.xy);
  float aspect = resolution.x / resolution.y;
  float circleSize = 0.01 * resolution.x;

  vec4 cColor = cellColor;
  vec4 bColor = vec4(0.0, 0.0, 0.0, 0.0);

  if (m != vec2(0.0, 0.0) && d < circleSize) {
		gl_FragColor = cColor;
	} else {
		float dx = 1.0 / resolution.x;
		float dy = 1.0 / resolution.y;
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
		if ( v0.a == 1.0 ) {
			//if ( s.a < 2.0 || s.a > 3.0 )
			if (minLiveNeighborRule <= s.a && s.a <= maxLiveNeighborRule)
				gl_FragColor = cColor;
			else
				gl_FragColor = bColor;
		// dead cell
		} else {
			if (minDeadNeighborRule <= s.a && s.a <= maxDeadNeighborRule)
				gl_FragColor = cColor;
		}
	}
}
