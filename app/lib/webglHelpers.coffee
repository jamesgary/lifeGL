define ['lib/gameLoop'], (gameLoop) ->
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
    gameLoop.loop(render)
  render = ->
    time = new Date().getTime() - parameters.start_time

    # Load program into GPU
    gl.useProgram(currentProgram)

    # Set values to program variables
    gl.uniform1f(gl.getUniformLocation(currentProgram, "time"), time / 1000)
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

    ###########
    # private #
    ###########

  }
