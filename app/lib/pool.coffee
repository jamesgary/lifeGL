# Example Usage
# Goat = ->
#   @init()
# Goat::init = (x, y) ->
#   @x = x
#   @y = y
#
# goatPool = new Pool(Goat)
# goat1 = goatPool.spawn(10, 20)
# goat2 = goatPool.spawn(30, 20)
# goat3 = goatPool.spawn(40, 40)
# goatPool.kill goat2

define ->
  Pool = (Cls) ->
    @cls = Cls
    @objpool = []

  Pool::spawn = ->
    obj = if @objpool.length > 0 then @objpool.pop() else new @cls()
    obj.init arguments...
    obj

  Pool::kill = (obj) ->
    for prop of obj
      delete obj[prop] # this might be faster in some cases: obj[prop] = null
    obj.init()
    @objpool.push obj

  Pool
