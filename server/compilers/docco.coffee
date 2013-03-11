module.exports = class Docco

  exec: require('child_process').exec
  docco: glob.config.bin.docco

  path:
    #TODO subfolders
    from: "#{glob.root}/src/coffee/*.coffee"
    to: "#{glob.root}/examples/public/docs/"

  constructor: (options) ->
    @cmd = "#{@docco} #{@path.from} -o #{@path.to}"

  compile: (cb)=>
    @exec @cmd, (err)=>
      console.log err if err
      cb() if cb
