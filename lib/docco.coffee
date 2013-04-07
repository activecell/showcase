exec = require('child_process').exec

module.exports = (options = {}) ->
  if !options.root or !options.files
    throw new Error('Not valid options for docco. Example: { files: "/src/coffee/*", output: "/public/docs", root: __dirname }')

  output = if options.output then "--output #{options.root + options.output}" else ''
  files  = options.root + options.files

  exec "#{__dirname}/../node_modules/docco/bin/docco #{output} #{files}", (err, stdout, stderr) ->
    console.log('docco exec error: ' + err || stderr) if err or stderr
    console.log('docco: ' + stdout)
