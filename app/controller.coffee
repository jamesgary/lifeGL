define ['models/acidTrip/acidTrip', 'jquery'], (acidTrip, $) ->
  setup: ->
    $('document').ready ->
      window.addEventListener(
        "resize",
        (event) -> acidTrip.setViewport(window.innerWidth, window.innerHeight)
        false
      )
      window.addEventListener(
        'mousemove',
        (event) -> acidTrip.blot(
          event.clientX,
          event.clientY,
        ),
        false
      )
      $('.playToggler').click( ->
        button = $(this)
        if button.hasClass('pause')
          acidTrip.pause()
          button.removeClass('pause')
          button.addClass('play')
          button.html("&#9658;")
        else
          acidTrip.start()
          button.removeClass('play')
          button.addClass('pause')
          button.html('I I')
      )

      acidTrip.tuneIn({
        canvas:   $('canvas')[0],
        width:    window.innerWidth,
        height:   window.innerHeight,
      })
      acidTrip.start()
