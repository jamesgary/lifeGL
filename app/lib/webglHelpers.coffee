define ['lib/gameLoop'], (gameLoop) -> {
  initGl: (@canvas) ->
    @initialize()
  animate: ->
    @compile()
    @paused = false
    gameLoop.loopThis(this, 'render')
  addFragmentShaders: (shaders) ->
    @addShaders(shaders, @fragmentShaderStrategy)
  addVertexShaders: (shaders) ->
    @addShaders(shaders, @vertexShaderStrategy)
  setDimensions: (@containerWidth, @containerHeight) ->
    @resetViewport()
  resetViewport: ->
    @width  = @containerWidth  / @pixelSize
    @height = @containerHeight / @pixelSize
    @canvas.width = @width
    @canvas.height = @height
    @gl.viewport(0, 0, @width, @height)
    @createTargets()
  setMouse: (x, y) ->
    @mouse = { x: x, y: y }
  pause: ->
    @paused = true
  reset: ->
    @createTargets()
  setVar: (name, val) ->
    @customVars[name] = val
  setPixelSize: (@pixelSize) ->
    @resetViewport()

  ###########
  # private #
  ###########

  # 2 triangles, making a rectangle
  squareData: new Float32Array([
    -1.0, -1.0,
     1.0, -1.0,
    -1.0,  1.0,
     1.0, -1.0,
     1.0,  1.0,
    -1.0,  1.0
  ])

  initialize: ->
    try
      @gl = @canvas.getContext("experimental-webgl")
    throw "cannot create webgl context" unless @gl

    # Create rectangular vertex buffer
    @buffer = @gl.createBuffer()
    @gl.bindBuffer(@gl.ARRAY_BUFFER, @buffer)
    @gl.bufferData(@gl.ARRAY_BUFFER, @squareData, @gl.STATIC_DRAW)
    @currentProgram = @gl.createProgram()

    # defaults
    @pixelSize = 1
    @containerWidth = 100
    @containerHeight = 100

    @resetViewport()
    @start_time = new Date().getTime()
    @customVars = {}
  compile: ->
    @gl.linkProgram(@currentProgram)
    unless @gl.getProgramParameter(@currentProgram, @gl.LINK_STATUS)
      console.error("VALIDATE_STATUS: " + @gl.getProgramParameter(@currentProgram, @gl.VALIDATE_STATUS), "ERROR: " + @gl.getError())

    # Load program into GPU
    @gl.useProgram(@currentProgram)

    # Set up buffers
    @gl.bindBuffer(             @gl.ARRAY_BUFFER, @buffer)
    @gl.vertexAttribPointer(    @someVertexPosition, 2, @gl.FLOAT, false, 0, 0)
    @gl.enableVertexAttribArray(@someVertexPosition)

  createTargets: ->
    @frontTarget = @createTarget()
    @backTarget  = @createTarget()
  createTarget: ->
    target = {}
    target.framebuffer  = @gl.createFramebuffer()
    target.renderbuffer = @gl.createRenderbuffer()
    target.texture      = @gl.createTexture()

    # set up framebuffer
    @gl.bindTexture          @gl.TEXTURE_2D,  target.texture
    @gl.texImage2D           @gl.TEXTURE_2D,  0, @gl.RGBA, @width, @height, 0, @gl.RGBA, @gl.UNSIGNED_BYTE, null
    @gl.texParameteri        @gl.TEXTURE_2D,  @gl.TEXTURE_WRAP_S, @gl.CLAMP_TO_EDGE
    @gl.texParameteri        @gl.TEXTURE_2D,  @gl.TEXTURE_WRAP_T, @gl.CLAMP_TO_EDGE
    @gl.texParameteri        @gl.TEXTURE_2D,  @gl.TEXTURE_MAG_FILTER, @gl.NEAREST
    @gl.texParameteri        @gl.TEXTURE_2D,  @gl.TEXTURE_MIN_FILTER, @gl.NEAREST
    @gl.bindFramebuffer      @gl.FRAMEBUFFER, target.framebuffer
    @gl.framebufferTexture2D @gl.FRAMEBUFFER, @gl.COLOR_ATTACHMENT0, @gl.TEXTURE_2D, target.texture, 0

    # set up renderbuffer
    @gl.bindRenderbuffer        @gl.RENDERBUFFER, target.renderbuffer
    @gl.renderbufferStorage     @gl.RENDERBUFFER, @gl.DEPTH_COMPONENT16, @width, @height
    @gl.framebufferRenderbuffer @gl.FRAMEBUFFER,  @gl.DEPTH_ATTACHMENT, @gl.RENDERBUFFER, target.renderbuffer

    # clean up
    @gl.bindTexture      @gl.TEXTURE_2D, null
    @gl.bindRenderbuffer @gl.RENDERBUFFER, null
    @gl.bindFramebuffer  @gl.FRAMEBUFFER, null
    target
  addShaders: (shaders, shaderStrategy) ->
    for shader in shaders
      shaderObj = shaderStrategy.call(this, shader)
      errorMessage = @gl.getShaderInfoLog(shaderObj)
      if errorMessage
        console.log("SHADER ERROR: " + errorMessage)
      else
        @gl.attachShader(@currentProgram, shaderObj)
  vertexShaderStrategy: (shader) ->
    @createShader(shader, @gl.VERTEX_SHADER)
  fragmentShaderStrategy: (shader) ->
    @createShader(shader, @gl.FRAGMENT_SHADER)
  createShader: (src, type) ->
    shader = @gl.createShader(type)
    @gl.shaderSource(shader, src)
    @gl.compileShader(shader)
    shader

  render: ->
    return if @paused || !@currentProgram

    # Set uniforms for custom shader
    @gl.useProgram( @currentProgram)
    @gl.uniform1f(@gl.getUniformLocation(@currentProgram, "time"), new Date().getTime() - @start_time)
    @gl.uniform2f(@gl.getUniformLocation(@currentProgram, "resolution"), @width, @height)
    @gl.uniform1i(@gl.getUniformLocation(@currentProgram, "backbuffer"), 0)
    @gl.uniform2f(@gl.getUniformLocation(@currentProgram, "mouse"), @mouse.x / @pixelSize, @mouse.y / @pixelSize) if @mouse

    for name, val of @customVars
      if val.length == 4
        @gl.uniform4f(@gl.getUniformLocation(@currentProgram, name), val...)
      else
        @gl.uniform1f(@gl.getUniformLocation(@currentProgram, name), val)

    @gl.activeTexture(@gl.TEXTURE0)
    @gl.bindTexture(@gl.TEXTURE_2D, @backTarget.texture)

    # Render custom shader to front buffer
    @gl.bindFramebuffer(@gl.FRAMEBUFFER, @frontTarget.framebuffer)
    @gl.clear(          @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT)
    @gl.drawArrays(     @gl.TRIANGLES, 0, 6)

    # Render front buffer to screen
    @gl.bindFramebuffer(@gl.FRAMEBUFFER, null)
    @gl.clear(          @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT)
    @gl.drawArrays(     @gl.TRIANGLES, 0, 6)

    # Swap buffers
    tmp = @frontTarget
    @frontTarget = @backTarget
    @backTarget = tmp
}
