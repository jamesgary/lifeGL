define ->
  init: (@grid, canvasElement) ->
    @ctx = canvasElement.getContext('2d')
    @ctx.fillStyle = @deadColor
    @width = @grid.width
    @height = @grid.height

    @canvas2 = document.createElement('canvas')
    @canvas2.width = @width
    @canvas2.height = @height
    @ctx2 = @canvas2.getContext('2d')
  draw: ->
    image = @makeGridImage(@grid.getCells())
    @ctx2.putImageData(image, 0, 0)
    @ctx.drawImage(@canvas2, 0, 0)

  ###########
  # private #
  ###########

  makeGridImage: (cells) ->
    image = @ctx.createImageData(@width, @height)
    pixels = image.data # already defaulted to [0,0,0,0,...]
    i = 0
    pixelCount = pixels.length
    while i < pixelCount
      actual_i = Math.floor(i / 4)
      if cells[Math.floor(actual_i % @width)][Math.floor(actual_i / @width)].living
        pixels[i + 3] = 255
      else
        pixels[i]     = 255
        pixels[i + 1] = 255
        pixels[i + 2] = 255
        pixels[i + 3] = 255 #200
      i += 4
    image
