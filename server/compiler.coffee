module.exports = class Compiler

  #modules
  fs: require 'fs'
  sass: require 'node-sass'
  async: require 'async'

  config: require './config'

  exec: require('child_process').exec
  spawn: require('child_process').spawn

  bin:
    coffee: "#{__dirname}/../node_modules/coffee-script/bin/coffee"
    docco: "#{__dirname}/../node_modules/docco/bin/docco"

  path:
    src_coffee_dir: "#{__dirname}/../src/coffee/"
    dest_docs_dir: "#{__dirname}/../examples/public/docs/"

  cmd: {}

  constructor: (options) ->
    if options
      @[o] = options[o] for o of options

    @path.src_coffee_dest = "#{__dirname}/../dist/#{@config.name}.js"

    @cmd =
      src_coffee:
        join: "#{@bin.coffee} -j #{@path.src_coffee_dest} -cb #{@path.src_coffee_dir}"
        show_errors: "#{@bin.coffee} -p -cb #{@path.src_coffee_dir}"

      docco: "#{@bin.docco} #{@src_coffee_dir}*.coffee -o #{@path.dest_docs_dir}"

    @compile.parallel = [@compile.src.coffee,@compile.src.css,@compile.tests,@compile.examples.coffee]

  start: (cb) ->
    @async.parallel @compile.parallel, =>
      @compile.src.docco =>
        cb() if cb

  compile:
    src:
      coffee: (cb) ->
        @exec @cmd.src_coffee.join, (err,stdout,stderr) =>
          if stderr
            @exec @cmd.src_coffee.show_errors, (err,stdout,stderr) =>
              console.log 'coffee err: ',stderr
              cb() if cb
          else
            cb() if cb

      docco: (cb)->
        @exec @cmd.docco, =>
          cb() if cb

      css: (cb) ->
        @compile.src[@config.css_engine] =>
          cb() if cb

      scss: (cb) ->
        scssPath = "#{__dirname}/../src/scss/#{glob.config.name}.scss"
        @fs.readFile scssPath, (err, scssFile) ->
          sass.render scssFile.toString(), (err, css) ->
            if err
              console.log err
              cb()
            else
              fs.writeFile "#{__dirname}/../dist/#{glob.config.name}.css", css, ->
                cb()
          , { include_paths: [ "#{__dirname}/../src/scss/"] }

      less: (cb) ->
        #lesscPath = "#{__dirname}/../node_modules/less/bin/lessc"
        #lessDest = "#{__dirname}/../src/less/index.less"
        #child_process.exec "#{lesscPath} #{lessDest}", (err,stdout,stderr) ->
          #console.log 'less err: ',stderr if stderr
          #fs.writeFile "#{__dirname}/../dist/#{name}.css", stdout, ->
            #cb()

    tests: (cb) ->
      testDest = "#{__dirname}/../examples/public/js/test.js"
      srcDir = "#{__dirname}/../test/unit/*_test.coffee"
      command1 = "#{@coffeePath} -j #{testDest} -cb #{srcDir}"
      command2 = "#{@coffeePath} -p -cb #{srcDir}"

      @exec command1, (err,stdout,stderr) ->
        if stderr
          @exec command2, (err,stdout,stderr) ->
            console.log 'coffee err: ',stderr
            cb()
        else
          cb()

    examples:
      coffee: (cb) ->
        destDir = "#{__dirname}/../examples/public/js/"
        srcDir = "#{__dirname}/../examples/public/coffee/"
        command1 = "#{@coffeePath} -o #{destDir} -cb #{srcDir}"
        command2 = "#{@coffeePath} -p -cb #{srcDir}"

        @exec command1, (err,stdout,stderr) ->
          if stderr
            @exec command2, (err,stdout,stderr) ->
              console.log 'coffee err: ',stderr
              cb()
          else
            cb()
