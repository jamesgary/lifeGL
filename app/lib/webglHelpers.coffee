define ['lib/gameLoop'], (gameLoop) ->
  {
    initGl: (params) ->
      @canvas = params.canvas
      try
        @gl = @canvas.getContext("experimental-webgl")
      throw "cannot create webgl context" unless @gl

      # Create Vertex buffer (2 triangles, making a rectangle)
      @gl.bindBuffer(@gl.ARRAY_BUFFER, @gl.createBuffer())
      @gl.bufferData(@gl.ARRAY_BUFFER, @squareData, @gl.STATIC_DRAW)

      @start_time = new Date().getTime()
    animate: ->
      @gl.useProgram(@currentProgram)
      gameLoop.loopThis(this, 'render')
    addFragmentShaders: (shaders) ->
      @addShaders(shaders, @fragmentShaderStrategy)
    addVertexShaders: (shaders) ->
      @addShaders(shaders, @vertexShaderStrategy)
    setViewport: (width, height) ->
      @gl.viewport(0, 0, width, height)
    setMouse: (x, y) ->
      @mouse = { x: x, y: y }

    ###########
    # private #
    ###########

    squareData: new Float32Array([
      -1.0, -1.0,
       1.0, -1.0,
      -1.0,  1.0,
       1.0, -1.0,
       1.0,  1.0,
      -1.0,  1.0
    ])
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

      # Set values to program variables
      @gl.uniform1f(@gl.getUniformLocation(@currentProgram, "time"), time)
      @gl.uniform2f(@gl.getUniformLocation(@currentProgram, "resolution"), @canvas.width, @canvas.height)
      @gl.uniform1i(@gl.getUniformLocation(@currentProgram, "backbuffer"), 0)

      if @mouse
        @gl.uniform2f(@gl.getUniformLocation(@currentProgram, "mouse"), @mouse.x, @mouse.y)

      # Render geometry
      @gl.vertexAttribPointer(@vertex_position, 2, @gl.FLOAT, false, 0, 0)
      @gl.enableVertexAttribArray(@vertex_position)
      @gl.drawArrays(@gl.TRIANGLES, 0, 6)
      @gl.disableVertexAttribArray(@vertex_position)
  }
