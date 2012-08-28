define ['lib/webglHelpers'], (webgl) ->
  tuneIn: (params) ->
    @canvas = params.canvas
    @gl = webgl.initGl(params)
    @applyTriangleBuffer()
    @windowResized() # prime the pump

    #webgl.createProgram(params.vertex, params.fragment)
  turnOn: ->
    webgl.animate()
  windowResized: (event) ->
    newWidth = window.innerWidth
    newHeight = window.innerHeight
    @canvas.width = newWidth
    @canvas.height = newHeight
    @gl.viewport(0, 0, newWidth, newHeight)

  ###########
  # private #
  ###########

  applyTriangleBuffer: ->
    # Create Vertex buffer (2 triangles)
    triangleData = new Float32Array([
      -1.0, -1.0,
       1.0, -1.0,
      -1.0,  1.0,
       1.0, -1.0,
       1.0,  1.0,
      -1.0,  1.0
    ])
    @gl.bindBuffer(@gl.ARRAY_BUFFER, @gl.createBuffer())
    @gl.bufferData(
      @gl.ARRAY_BUFFER,
      triangleData,
      @gl.STATIC_DRAW
    )
