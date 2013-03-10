module.exports = class Css

  fs: require 'fs'
  sass: require 'node-sass'

  path:
    src:
      include_paths: [ "#{glob.root}/src/scss/"]
      from: "#{__dirname}/../src/scss/#{glob.config.name}.scss"
      to: "#{__dirname}/../dist/#{glob.config.name}.css"
    #TODO
    #examples:
      #from: null
      #to: null

  compile_src: (cb) =>
    @["compile_src_#{glob.config.css_engine}"] =>
      cb() if cb

  compile_src_scss: (cb) =>
    @fs.readFile @path.src.from, (err, scssFile) =>
      scssFile = '' unless scssFile?
      @sass.render scssFile.toString(), (err, css) =>
        if err
          console.log err
          cb() if cb
        else
          @fs.writeFile @path.src.to, css, =>
            cb() if cb
      , { include_paths: @path.src.include_paths }

  #TODO
  #less: (cb) ->
    #lesscPath = "#{__dirname}/../node_modules/less/bin/lessc"
    #lessDest = "#{__dirname}/../src/less/index.less"
    #child_process.exec "#{lesscPath} #{lessDest}", (err,stdout,stderr) ->
      #console.log 'less err: ',stderr if stderr
      #fs.writeFile "#{__dirname}/../dist/#{name}.css", stdout, ->
        #cb()

