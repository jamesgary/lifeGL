requirejs.config({
  paths:
    jquery:     'vendor/jquery'
    miniColors: 'vendor/jquery.miniColors'
    nouislider: 'vendor/jquery.nouislider'
    text:       'vendor/text'
  shim:
    'miniColors':
      deps: ['jquery']
    'nouislider':
      deps: ['jquery']
})

require ["controller"], (controller) ->
  controller.setup()
