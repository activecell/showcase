module.exports = class Coffee

  exec: require('child_process').exec

  coffee: "#{glob.root}/node_modules/coffee-script/bin/coffee"

  path:
    src:
      from: "#{glob.root}/src/coffee/"
      to: "#{glob.root}/dist/#{glob.config.name}.js"
    test:
      from: "#{glob.root}/test/unit/*_test.coffee"
      to: "#{glob.root}/examples/public/js/test.js"
    examples:
      from: "#{glob.root}/examples/public/coffee/"
      to: "#{glob.root}/examples/public/js/"

  cmd:
    src:
      join: null
      error: null

  constructor: ->

    @cmd =
      src:
        join: "#{@coffee} -j #{@path.src.to} -cb #{@path.src.from}"
        error: "#{@coffee} -p -cb #{@path.src.from}"
      test:
        join: "#{@coffee} -j #{@path.test.to} -cb #{@path.test.from}"
        error: "#{@coffee} -p -cb #{@path.test.from}"
      examples:
        compile: "#{@coffee} -o #{@path.examples.to} -cb #{@path.examples.from}"
        error: "#{@coffee} -p -cb #{@path.examples.from}"

  compile_src: (cb) =>
    @exec @cmd.src.join, (err,stdout,stderr) =>
      if stderr
        @exec @cmd.src.error, (err,stdout,stderr) =>
          console.log 'coffee err: ',stderr
          cb() if cb
      else
        cb() if cb

  compile_tests: (cb) =>
    @exec @cmd.test.join, (err,stdout,stderr) ->
      if stderr
        @exec @cmd.test.error, (err,stdout,stderr) ->
          console.log 'coffee err: ',stderr
          cb()
      else
        cb()

  compile_examples: (cb) =>
    @exec @cmd.examples.compile, (err,stdout,stderr) ->
      if stderr
        @exec @cmd.examples.error, (err,stdout,stderr) ->
          console.log 'coffee err: ',stderr
          cb()
      else
        cb()
