_ = require('underscore')

exports.path = (paths...) ->
  escapedFiles = paths.map((pattern) ->
    pattern.replace(/[\-\[\]\/\{\}\(\)\+\?\.\\\^\$\|]/g, "\\$&")
  ).join('|')
  new RegExp('^' + escapedFiles)

exports.defaultConfig = (config) ->
  defaultConfig =
    paths:
      app: 'src'

    plugins:
      sass:
        debug: 'comments'

    modules:
      definition: false
      # module wrapper
      wrapper: (path, data) ->
        if path.match(/\.(coffee|hbs)$/)
          data = """
          (function() {
            #{data}
          }).call(this);
          """
        data + '\n\n'

  _.defaults(config, defaultConfig)
