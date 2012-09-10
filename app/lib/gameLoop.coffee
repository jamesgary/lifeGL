define ->
  raf =
    window.requestAnimationFrame       ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame    ||
    window.oRequestAnimationFrame      ||
    window.msRequestAnimationFrame     ||
    (callback) ->
      window.setTimeout(callback, 1000 / 60)
  {
    # CAUTION: Only works if `f` doesn't use `this`
    loop: (f) ->
      step = ->
        f()
        raf(step)
      step()
    # For use if your function uses `this`
    # Example:
    # {
    #   start: ->
    #     gameLoop.loopThis(this, 'render')
    #   # private
    #   render: ->
    #     @privateDrawFunction()
    #   privateDrawFunction: () -> ...
    # }
    loopThis: (parentObject, functionName) ->
      step = ->
        parentObject[functionName]()
        raf(step)
      step()
  }
