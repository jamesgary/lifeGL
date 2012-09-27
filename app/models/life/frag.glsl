#ifdef GL_ES
precision highp float;
#endif

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
  vec2  pos = gl_FragCoord.xy / resolution.xy;
  vec2  mousePos = vec2(mouse.x, resolution.y - mouse.y); // invert the mouse
  float dist = distance(gl_FragCoord.xy, mousePos.xy);
  float aspect = resolution.x / resolution.y;
  float circleSize = 0.01 * resolution.x;

  vec4 bgColor = vec4(0.0, 0.0, 0.0, 0.0); // clear

  if (mousePos.x != 0.0 && mousePos.y != 0.0 && dist < circleSize) {
		gl_FragColor = cellColor;
	} else {
		float dx = 1.0 / resolution.x;
		float dy = 1.0 / resolution.y;
		vec4 self = texture2D( backbuffer, pos );
    vec4 neighbors[8];
    neighbors[0] = texture2D(backbuffer, pos + vec2(0.0,  dy));
    neighbors[1] = texture2D(backbuffer, pos + vec2( dx, 0.0));
    neighbors[2] = texture2D(backbuffer, pos + vec2(0.0, -dy));
    neighbors[3] = texture2D(backbuffer, pos + vec2(-dx, 0.0));
    neighbors[4] = texture2D(backbuffer, pos + vec2( dx,  dy));
    neighbors[5] = texture2D(backbuffer, pos + vec2(-dx, -dy));
    neighbors[6] = texture2D(backbuffer, pos + vec2( dx, -dy));
    neighbors[7] = texture2D(backbuffer, pos + vec2(-dx,  dy));

    vec4 sum = vec4(0.0, 0.0, 0.0, 0.0);
    for(int i = 0; i < 8; i++) {
      sum += neighbors[i];
    }

		
		if ( self.a == 1.0 ) { // live cell
			if (minLiveNeighborRule <= sum.a && sum.a <= maxLiveNeighborRule)
				gl_FragColor = cellColor;
			else
				gl_FragColor = bgColor;
		} else { // dead cell
			if (minDeadNeighborRule <= sum.a && sum.a <= maxDeadNeighborRule)
				gl_FragColor = cellColor;
		}
	}
}
