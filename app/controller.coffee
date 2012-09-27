define ['models/life/life', 'jquery', 'miniColors', 'nouislider'], (life, $) ->
  setup: ->
    self = this
    $('document').ready ->
      self.setWindowListener()
      self.setMouseListener()
      self.setPlayListener()
      self.setResetListener()
      self.setColorListener()
      self.setCellSizeListener()
      self.startLife()

  ###########
  # private #
  ###########

  setWindowListener: ->
    window.addEventListener(
      "resize",
      (event) -> life.setDimensions(window.innerWidth, window.innerHeight)
      false
    )

  setMouseListener: ->
    window.addEventListener(
      'mousemove',
      (event) -> life.setMouse(
        event.clientX,
        event.clientY,
      ),
      false
    )

  setPlayListener: ->
    $('.playToggler').click( ->
      button = $(this)
      if button.hasClass('pause')
        life.pause()
        button.removeClass('pause')
        button.addClass('play')
        button.html("&#9658;")
      else
        life.start()
        button.removeClass('play')
        button.addClass('pause')
        button.html('I I')
    )

  setResetListener: ->
    $('.reset').click(life.reset)

  setColorListener: ->
    rgb2hex = (rgb) ->
      rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
      hex = (x) ->
        ("0" + parseInt(x).toString(16)).slice(-2)
      "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])
    $('.colorPicker .cell').miniColors({
      opacity: false,
      change: (hex, rgb) ->
        life.setCellColor(rgb.r, rgb.g, rgb.b)
    }).miniColors('value', life.cellColor)
    $('.colorPicker .background').miniColors({
      opacity: false,
      change: (hex, rgb) ->
        $('body').css('background-color', hex)
    }).miniColors('value', rgb2hex($('body').css('background-color')))

  setCellSizeListener: ->
    oldPixelSize = 1
    $('.cellSize').noUiSlider('init', {
      scale: [1, 10],
      start: [oldPixelSize],
      knobs: 1,
      connect: 'lower',
      change: ->
        size = $(this).noUiSlider('value')[1]
        unless size == oldPixelSize # don't do unnecessary work
          life.setPixelSize(size)
          oldPixelSize = size
    })

  startLife: ->
    life.setup({
      canvas:   $('canvas')[0],
      width:    window.innerWidth,
      height:   window.innerHeight,
    })
    life.start()
