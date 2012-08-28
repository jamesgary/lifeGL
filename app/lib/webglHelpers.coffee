# Provides requestAnimationFrame in a cross browser way.
# paulirish.com/2011/requestanimationframe-for-smart-animating/
define ->
  requestAnimationFrame =
    window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    (callback, element) -> window.setTimeout( callback, 1000 / 60 )

  canvas = undefined
  gl = undefined
  buffer = undefined
  fragment_shader = undefined
  currentProgram = undefined
  vertex_position = undefined
  parameters =
    start_time: new Date().getTime()
    time: 0
    screenWidth: 0
    screenHeight: 0

  initGl = (params) ->
    canvas = params.canvas
    try
      gl = canvas.getContext("experimental-webgl")
    throw "cannot create webgl context" unless gl

    # Create Vertex buffer (2 triangles)
    buffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array([
        -1.0, -1.0,
         1.0, -1.0,
        -1.0,  1.0,
         1.0, -1.0,
         1.0,  1.0,
        -1.0,  1.0
      ]),
      gl.STATIC_DRAW)

    gl
  createProgram = (vertex, fragment) ->
    program = gl.createProgram()
    attachShader(createVertexShader(vertex), program)
    attachShader(createFragmentShader(fragment), program)
    gl.linkProgram(program)
    currentProgram = program # for global vars
  createVertexShader   = (shader) -> createShader(shader, gl.VERTEX_SHADER)
  createFragmentShader = (shader) -> createShader("#ifdef GL_ES\nprecision highp float;\n#endif\n\n" + shader, gl.FRAGMENT_SHADER)
  attachShader = (shader, program) ->
    gl.attachShader(program, shader)
    gl.deleteShader(shader)

  createShader = (src, type) ->
    shader = gl.createShader(type)
    gl.shaderSource(shader, src)
    gl.compileShader(shader)
    shader
  animate = ->
    requestAnimationFrame(animate)
    render()
  render = ->
    return unless currentProgram
    parameters.time = new Date().getTime() - parameters.start_time
    gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

    # Load program into GPU
    gl.useProgram(currentProgram)

    # Set values to program variables
    gl.uniform1f(gl.getUniformLocation(currentProgram, "time"), parameters.time / 1000)
    gl.uniform2f(gl.getUniformLocation(currentProgram, "resolution"), canvas.width, canvas.height)

    # Render geometry
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
    gl.vertexAttribPointer(vertex_position, 2, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(vertex_position)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
    gl.disableVertexAttribArray(vertex_position)


  {
    initGl: initGl
    animate: animate
    createProgram: createProgram
  }
