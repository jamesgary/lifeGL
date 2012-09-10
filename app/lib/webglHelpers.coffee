define ['lib/gameLoop'], (gameLoop) ->
  {
    initGl: (params) ->
      @canvas = params.canvas
      try
        @gl = @canvas.getContext("experimental-webgl")
      throw "cannot create webgl context" unless @gl

      # Create Vertex buffer (2 triangles)
      @buffer = @gl.createBuffer()
      @gl.bindBuffer(@gl.ARRAY_BUFFER, @buffer)
      @gl.bufferData(
        @gl.ARRAY_BUFFER,
        new Float32Array([
          -1.0, -1.0,
           1.0, -1.0,
          -1.0,  1.0,
           1.0, -1.0,
           1.0,  1.0,
          -1.0,  1.0
        ]),
        @gl.STATIC_DRAW)

      @start_time = new Date().getTime()
      @gl
    animate: ->
      gameLoop.loopThis(this, 'render')
    addFragmentShaders: (shaders) ->
      @addShaders(shaders, @fragmentShaderStrategy)
    addVertexShaders: (shaders) ->
      @addShaders(shaders, @vertexShaderStrategy)

    ###########
    # private #
    ###########

    addShaders: (shaders, shaderStrategy) ->
      @currentProgram = @currentProgram || @gl.createProgram()
      for shader in shaders
        @gl.attachShader(@currentProgram, shaderStrategy.call(this, shader))
      @gl.linkProgram(@currentProgram)
    vertexShaderStrategy: (shader) ->
      @createShader(shader, @gl.VERTEX_SHADER)
    fragmentShaderStrategy: (shader) ->
      @createShader("#ifdef GL_ES\nprecision highp float;\n#endif\n\n" + shader, @gl.FRAGMENT_SHADER)
    createShader: (src, type) ->
      shader = @gl.createShader(type)
      @gl.shaderSource(shader, src)
      @gl.compileShader(shader)
      shader
    render: ->
      time = new Date().getTime() - @start_time

      # Load program into GPU
      @gl.useProgram(@currentProgram)

      # Set values to program variables
      @gl.uniform1f(@gl.getUniformLocation(@currentProgram, "time"), time / 1000)
      @gl.uniform2f(@gl.getUniformLocation(@currentProgram, "resolution"), @canvas.width, @canvas.height)

      # Render geometry
      @gl.bindBuffer(@gl.ARRAY_BUFFER, @buffer)
      @gl.vertexAttribPointer(@vertex_position, 2, @gl.FLOAT, false, 0, 0)
      @gl.enableVertexAttribArray(@vertex_position)
      @gl.drawArrays(@gl.TRIANGLES, 0, 6)
      @gl.disableVertexAttribArray(@vertex_position)
  }
