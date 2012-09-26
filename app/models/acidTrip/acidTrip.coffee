define ['lib/webglHelpers', 'text!./frag.glsl', 'text!./vert.glsl' ], (webgl, fragShader, vertShader) ->
  tuneIn: (params) ->
    webgl.initGl(params.canvas)
    webgl.addVertexShaders([vertShader])
    webgl.addFragmentShaders([fragShader])
    @setViewport(params.width, params.height) # prime the pump
  start: ->
    webgl.animate()
  pause: ->
    webgl.pause()
  setViewport: (width, height) ->
    webgl.setViewport(width, height)
  blot: (x, y) ->
    webgl.setMouse(x, y)
