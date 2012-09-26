define ['lib/webglHelpers', 'text!./frag.glsl', 'text!./vert.glsl' ], (webgl, fragShader, vertShader) ->
  setup: (params) ->
    webgl.initGl(params.canvas)
    webgl.addVertexShaders([vertShader])
    webgl.addFragmentShaders([fragShader])
    @setViewport(params.width, params.height) # prime the pump
    @cellColor = 'a8f565'
    webgl.setVar('cellColor', @hexToGlslRgb(@cellColor))
  start: ->
    webgl.animate()
  pause: ->
    webgl.pause()
  setViewport: (width, height) ->
    webgl.setViewport(width, height)
  setMouse: (x, y) ->
    webgl.setMouse(x, y)
  reset: ->
    webgl.reset()
  fullScreen: ->
    webgl.fullScreen()
  setCellColor: (r, g, b) ->
    webgl.setVar('cellColor', @glslRgb(r, g, b))

  ###########
  # private #
  ###########

  hexToGlslRgb: (hex) ->
    @glslRgb(
      parseInt(hex[0] + hex[1], 16),
      parseInt(hex[2] + hex[3], 16),
      parseInt(hex[4] + hex[5], 16)
    )

  glslRgb: (r, g, b) ->
    [r / 255.0, g / 255.0, b / 255.0, 1.0]
