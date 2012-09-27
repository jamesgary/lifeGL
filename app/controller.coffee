define ['models/life/life', 'jquery', 'miniColors'], (life, $) ->
  setup: ->
    self = this
    $('document').ready ->
      self.setWindowListener()
      self.setMouseListener()
      self.setHiderListener()
      self.setPlayListener()
      self.setResetListener()
      self.setColorListener()
      self.setCellSizeListener()
      self.setLiveNeighborRuleListener()
      self.setDeadNeighborRuleListener()
      self.startLife()

  ###########
  # private #
  ###########

  setWindowListener: ->
    window.addEventListener(
      "resize",
      (event) -> life.setDimensions(window.innerWidth, window.innerHeight)
      false
    )

  setMouseListener: ->
    window.addEventListener(
      'mousemove',
      (event) -> life.setMouse(
        event.clientX,
        event.clientY,
      ),
      false
    )

  setHiderListener: ->
    $('.hide').click(->
      $('.dashboard').fadeToggle('fast')
      $(this).toggleClass('hidden')
    )

  setPlayListener: ->
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

  setResetListener: ->
    $('.reset').click(life.reset)

  setColorListener: ->
    rgb2hex = (rgb) ->
      rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
      hex = (x) ->
        ("0" + parseInt(x).toString(16)).slice(-2)
      "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])
    $('.colorPicker .cell').miniColors({
      opacity: false,
      change: (hex, rgb) ->
        life.setCellColor(rgb.r, rgb.g, rgb.b)
    }).miniColors('value', life.cellColor)
    $('.colorPicker .background').miniColors({
      opacity: false,
      change: (hex, rgb) ->
        $('body').css('background-color', hex)
    }).miniColors('value', rgb2hex($('body').css('background-color')))

  setCellSizeListener: ->
    sizes = [1, 2, 3, 4, 5]
    $select = $('select.cellSize')
    for size in sizes
      $select.append($('<option/>', {value: size, text: size }))
    $select.change(->
      size = @value
      life.setPixelSize(size)
    )

  setLiveNeighborRuleListener: ->
    $cellMin = $('select.liveCellMin')
    $cellMax = $('select.liveCellMax')
    @giveOptions($cellMin, @numToNum(0, 3))
    @giveOptions($cellMax, @numToNum(2, 8))
    self = this
    $cellMin.change(->
      self.giveOptions($cellMax, self.numToNum(@value, 8))
      life.setMinLiveNeighborRule(@value)
    )
    $cellMax.change(->
      self.giveOptions($cellMin, self.numToNum(0, @value))
      life.setMaxLiveNeighborRule(@value)
    )
    $cellMin.val(2)
    $cellMax.val(3)

  setDeadNeighborRuleListener: ->
    $cellMin = $('select.deadCellMin')
    $cellMax = $('select.deadCellMax')
    @giveOptions($cellMin, @numToNum(0, 3))
    @giveOptions($cellMax, @numToNum(3, 8))
    self = this
    $cellMin.change(->
      self.giveOptions($cellMax, self.numToNum(@value, 8))
      life.setMinDeadNeighborRule(@value)
    )
    $cellMax.change(->
      self.giveOptions($cellMin, self.numToNum(0, @value))
      life.setMaxDeadNeighborRule(@value)
    )
    $cellMin.val(3)
    $cellMax.val(3)

  startLife: ->
    life.setup({
      canvas:   $('canvas')[0],
      width:    window.innerWidth,
      height:   window.innerHeight,
    })
    life.start()

  ############################################
  # functions not called directly by setup() #
  ############################################

  giveOptions: ($select, array) ->
    originalValue = $select.val()
    $select.html('')
    for i in array
      $select.append($('<option/>', {value: i, text: i}))
    $select.val(originalValue)

  numToNum: (a, b) ->
    a = parseInt(a)
    b = parseInt(b)
    return [] if a > b
    array = []
    while a <= b
      array.push a
      a += 1
    array
