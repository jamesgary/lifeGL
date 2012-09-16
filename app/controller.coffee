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

      acidTrip.tuneIn({
        canvas:   $('canvas')[0],
        width:    window.innerWidth,
        height:   window.innerHeight,
      })
      acidTrip.turnOn()
