module.exports = class Coffee

  fs: require 'fs'
  exec: require('child_process').exec

  coffee: glob.config.bin.coffee
  path: glob.config.path.coffee

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
    @fs.unlink @path.src.to, =>
      @exec @cmd.src.join, (err,stdout,stderr) =>
        if err
          console.error err
          process.exit()
        else if stderr
          @exec @cmd.src.error, (err,stdout,stderr) =>
            console.error stderr
            process.exit()
        else
          cb() if cb

  compile_tests: (cb) =>
    @fs.unlink @path.test.to, =>
      @exec @cmd.test.join, (err,stdout,stderr) ->
        if err
          console.error err
          process.exit()
        else if stderr
          @exec @cmd.test.error, (err,stdout,stderr) ->
            console.error stderr
            process.exit()
        else
          cb()

  compile_examples: (cb) =>
    @fs.unlink @path.examples.to, =>
      @exec @cmd.examples.compile, (err,stdout,stderr) ->
        if err
          console.error err
          process.exit()
        else if stderr
          @exec @cmd.examples.error, (err,stdout,stderr) ->
            console.error stderr
            process.exit()
        else
          cb()
