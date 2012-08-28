define ->
  init: (@width, @height) ->
    @activeGrid = {}
    @inactiveGrid = {}
    for grid in [@activeGrid, @inactiveGrid]
      grid.cells = []
      for x in [0...@width]
        grid.cells[x] = []
        for y in [0...@height]
          grid.cells[x][y] = {
            living: false,
            livingNeighborCount: 0,
            neighbors: [],
          }
      for x in [0...@width]
        for y in [0...@height]
          cell = grid.cells[x][y]
          onLeftEdge  = x == 0
          onRightEdge = x + 1 == @width
          cell.neighbors.push(grid.cells[x - 1][y]) unless onLeftEdge
          cell.neighbors.push(grid.cells[x + 1][y]) unless onRightEdge
          upOne = y - 1
          if upOne >= 0
            cell.neighbors.push(grid.cells[x][upOne])
            cell.neighbors.push(grid.cells[x - 1][upOne]) unless onLeftEdge
            cell.neighbors.push(grid.cells[x + 1][upOne]) unless onRightEdge
          downOne = y + 1
          if downOne < @height
            cell.neighbors.push(grid.cells[x][downOne])
            cell.neighbors.push(grid.cells[x - 1][downOne]) unless onLeftEdge
            cell.neighbors.push(grid.cells[x + 1][downOne]) unless onRightEdge
  generate: ->
    for x in [0...@width]
      for y in [0...@height]
        cell = @activeGrid.cells[x][y]
        currentlyLiving = cell.living
        willLive = @shouldLive(currentlyLiving, cell.livingNeighborCount)
        if currentlyLiving != willLive
          inactiveCell = @inactiveGrid.cells[x][y]
          inactiveCell.living = willLive
          count = if willLive then 1 else -1
          for neighbor in inactiveCell.neighbors
            neighbor.livingNeighborCount += count
    [@activeGrid, @inactiveGrid] = [@inactiveGrid, @activeGrid]
    x = 0
    while x < @width
      y = 0
      while y < @height
        cell = @activeGrid.cells[x][y]
        inactiveCell = @inactiveGrid.cells[x][y]
        inactiveCell.living = cell.living
        inactiveCell.livingNeighborCount = cell.livingNeighborCount
        y++
      x++
  getCells: ->
    @activeGrid.cells
  randomize: ->
    for x in [0...@width]
      for y in [0...@height]
        living = Math.random() > .5
        for grid in [@activeGrid, @inactiveGrid]
          cell = grid.cells[x][y]
          cell.living = living
          if living
            for neighbor in cell.neighbors
              neighbor.livingNeighborCount++

  ###########
  # private #
  ###########

  cellAt: (x, y) ->
    @getCells()[x][y]
  shouldLive: (isLiving, neighborCount) ->
    if isLiving
      neighborCount == 2 || neighborCount == 3
    else
      neighborCount == 3
