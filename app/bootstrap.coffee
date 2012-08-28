requirejs.config({
  paths: {
    jquery: '../vendor/jquery'
  }
})

require ["controller"], (controller) ->
  controller.setup()
