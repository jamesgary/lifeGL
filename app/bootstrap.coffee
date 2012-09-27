requirejs.config({
  paths:
    jquery:     'vendor/jquery'
    miniColors: 'vendor/jquery.miniColors'
    text:       'vendor/text'
  shim:
    'miniColors':
      deps: ['jquery']
})

require ["controller"], (controller) ->
  controller.setup()
