requirejs.config({
  paths: {
    jquery: 'vendor/jquery'
    text: 'vendor/text'
  }
})

require ["controller"], (controller) ->
  controller.setup()
