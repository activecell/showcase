module.exports = class Docco

  exec: require('child_process').exec
  docco: "#{glob.root}/node_modules/docco/bin/docco"

  path:
    #TODO subfolders
    from: "#{glob.root}/src/coffee/*.coffee"
    to: "#{glob.root}/examples/public/docs/"

  constructor: (options) ->
    @cmd = "#{@docco} #{@path.from} -o #{@path.to}"

  compile: (cb)->
    @exec @cmd, =>
      cb() if cb
