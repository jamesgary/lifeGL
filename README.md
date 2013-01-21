#h1 Conway's Game of Life - Powered by WebGL

![Screenshot](link_me)

[Play with it now](http://codingcats.com/life). Requires any modern browser (this, of course, rules out any version of IE).

#h2 Goals

- Super duper fast Life simulation
  - Spins up instantly on the browser
  - Customizable options
- Keep the code organized with require.js
- Keep the code expressive with Coffeescript, SASS, and HAML
- Keep the code streamlined with Guard
- Play around with WebGL from the ground up
  - In hindsight, using a library like Three.js would have been less of a headache

#h2 Development

You'll have to start guard to compile Coffeescript, SASS, and HAML, as well as other handy file management.

In your shell console, run the following:

```shell
bundle install
bundle exec guard
```

Guard doesn't always compile all files on start up, so run `./script/clean` while guard is running to 'force' a recompile.

It's also much easier if you run your files behind a server to avoid 'local file' security warnings. This project is already set up as a rack app if you run the following in your shell console:

```shell
rackup
open http://localhost:9292/public/dev/index.html
```
