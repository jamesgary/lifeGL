define ['lib/webglHelpers', 'text!./frag.glsl', 'text!./vert.glsl' ], (webgl, fragShader, vertShader) ->
  setup: (params) ->
    webgl.initGl(params.canvas)
    webgl.addVertexShaders([vertShader])
    webgl.addFragmentShaders([fragShader])
    @setDimensions(params.width, params.height)
    @cellColor = 'a8f565'
    webgl.setVar('cellColor', @hexToGlslRgb(@cellColor))
    webgl.setVar('minLiveNeighborRule', 2)
    webgl.setVar('maxLiveNeighborRule', 3)
    webgl.setVar('minDeadNeighborRule', 3)
    webgl.setVar('maxDeadNeighborRule', 3)
  start: ->
    webgl.animate()
  pause: ->
    webgl.pause()
  setDimensions: (width, height) ->
    webgl.setDimensions(width, height)
  setMouse: (x, y) ->
    webgl.setMouse(x, y)
  reset: ->
    webgl.reset()
  fullScreen: ->
    webgl.fullScreen()
  setCellColor: (r, g, b) ->
    webgl.setVar('cellColor', @glslRgb(r, g, b))
  setPixelSize: (pixelSize) ->
    #console.log pixelSize
    webgl.setPixelSize(pixelSize)
  setMinLiveNeighborRule: (num) ->
    webgl.setVar('minLiveNeighborRule', num)
  setMaxLiveNeighborRule: (num) ->
    webgl.setVar('maxLiveNeighborRule', num)
  setMinDeadNeighborRule: (num) ->
    webgl.setVar('minDeadNeighborRule', num)
  setMaxDeadNeighborRule: (num) ->
    webgl.setVar('maxDeadNeighborRule', num)

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
