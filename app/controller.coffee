define ['models/acidTrip/acidTrip', 'jquery'], (acidTrip, $) ->
  setup: ->
    $('document').ready ->
      window.addEventListener(
        "resize",
        (event) -> acidTrip.setViewport(window.innerWidth, window.innerHeight)
        false
      )

      acidTrip.tuneIn({
        canvas:   $('canvas')[0],
        width:    window.innerWidth,
        height:   window.innerHeight,
      })
      acidTrip.turnOn()
