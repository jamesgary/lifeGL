define ['models/life/life', 'jquery', 'miniColors'], (life, $) ->
  setup: ->
    $('document').ready ->
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
          life.setCellColor(rgb.r, rgb.b, rgb.b)
      })
      $('.colorPicker .background').miniColors({
        opacity: false,
        change: (hex, rgb) ->
          $('body').css('background-color', hex)
      })

      life.setup({
        canvas:   $('canvas')[0],
        width:    window.innerWidth,
        height:   window.innerHeight,
      })
      life.start()
