define ['models/acidTrip', 'jquery'], (acidTrip, $) ->
  setup: ->
    $('document').ready ->
      window.addEventListener("resize", acidTrip.windowResized, false)

      acidTrip.tuneIn({
        canvas:   $('canvas')[0],
        vertex:   $('#vs')[0].textContent,
        fragment: $('#fs')[0].textContent,
      })
      acidTrip.turnOn()
