define ["lib/gameLoop", 'models/grid', 'views/gridView'], (gameLoop, grid, gridView) ->
  genAndDraw = ->
    grid.generate()
    gridView.draw()
  {
    startGame: (canvasElement) ->
      grid.init(canvasElement.width, canvasElement.height)
      grid.randomize()
      gridView.init(grid, canvasElement)
      console.log 'Initialized!'
      gameLoop.loop(genAndDraw)
  }
