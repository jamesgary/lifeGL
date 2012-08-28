define ['models/acidTrip', 'jquery'], (acidTrip, $) ->
  setup: ->
    $('document').ready ->
      window.addEventListener(
        "resize",
        (event) -> acidTrip.setViewport(window.innerWidth, window.innerHeight)
        false
      )

      acidTrip.tuneIn({
        canvas:   $('canvas')[0],
        vertex:   $('#vs')[0].textContent,
        fragment: $('#fs')[0].textContent,
        width:    window.innerWidth,
        height:   window.innerHeight,
      })
      acidTrip.turnOn()
