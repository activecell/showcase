module.exports = class Lint

  fs: require 'fs'
  coffeelint: require 'coffeelint'
  utils: new (require '../utils')

  getFiles: (cb)->
    files = []
    if glob.config.lint? and glob.config.lint[0]
      @utils.getDirs glob.config.lint, (_files)=>
        for file in _files
          if file.substr(-7) is '.coffee'
            files.push file
        cb files if cb
    else
      cb files if cb

  compile: (cb)=>
    @getFiles (files)=>
      if files[0]
        errors = {}
        for file in files
          content = @fs.readFileSync file, 'utf-8'
          path = file.split(glob.config.root)[1].substring(1)
          errors[path] = @coffeelint.lint content
        glob.server.lint_errors = errors
        cb() if cb
      else
        cb() if cb
