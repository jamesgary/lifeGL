define ['models/life/life', 'jquery', 'miniColors', 'nouislider'], (life, $) ->
  setup: ->
    $('document').ready ->
      rgb2hex = (rgb) ->
        rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
        hex = (x) ->
          ("0" + parseInt(x).toString(16)).slice(-2)
        "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])

      life.setup({
        canvas:   $('canvas')[0],
        width:    window.innerWidth,
        height:   window.innerHeight,
      })

      window.addEventListener(
        "resize",
        (event) -> life.setViewport(window.innerWidth, window.innerHeight)
        false
      )
      window.addEventListener(
        'mousemove',
        (event) -> life.setMouse(
          event.clientX,
          event.clientY,
        ),
        false
      )
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
      $('.reset').click(life.reset)
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

      $('.cellSize').noUiSlider('init', {
        knobs: 1
      })

      life.start()
