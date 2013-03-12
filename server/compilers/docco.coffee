module.exports = class Docco

  fs: require 'fs'
  exec: require('child_process').exec
  docco: glob.config.bin.docco

  path: glob.config.path.docco

  constructor: (options) ->
    @cmd = "#{@docco} #{@path.from} -o #{@path.to}"

  compile: (cb)=>
    #TODO subfolders
    @fs.readdir @path.to, (err,files)=>
      if files and files[0]
        for file in files
          @fs.unlinkSync @path.to+file
      @exec @cmd, (err)=>
        if err
          console.error err
          process.exit()
        else
          cb() if cb
