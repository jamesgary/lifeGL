define ['lib/webglHelpers', 'text!./frag.glsl', 'text!./vert.glsl' ], (webgl, fragShader, vertShader) ->
  tuneIn: (params) ->
    @canvas = params.canvas
    @gl = webgl.initGl(params)
    webgl.addVertexShaders([vertShader])
    webgl.addFragmentShaders([fragShader])
    @setViewport(params.width, params.height)
  turnOn: ->
    webgl.animate()
  setViewport: (width, height) ->
    @canvas.width = width
    @canvas.height = height
    @gl.viewport(0, 0, width, height)
  blot: (x, y) ->
    webgl.setMouse(x, y)
