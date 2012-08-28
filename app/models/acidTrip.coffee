define ['lib/webglHelpers'], (webgl) ->
  tuneIn: (params) ->
    @canvas = params.canvas
    @gl = webgl.initGl(params)
    webgl.createProgram(params.vertex, params.fragment)
    #@applyTriangleBuffer()
    @setViewport(params.width, params.height)
  turnOn: ->
    webgl.animate()
  setViewport: (width, height) ->
    @canvas.width = width
    @canvas.height = height
    @gl.viewport(0, 0, width, height)

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
