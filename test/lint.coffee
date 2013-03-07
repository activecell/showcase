describe 'coffeelint', ->
  it 'exec', (done)->
    report = ''
    glob.lint = require('child_process').spawn 'coffeelint', [
      '-f',
      './coffeelint.json',
      '-r',
      './examples'
      './server'
      './src'
      './test'
    ]
    glob.lint.stdout.on 'data', (data) ->
      data = data.toString()
      report += data
      unless glob.report
        process.stdout.write data
    glob.lint.on 'exit', ->
      require('fs').writeFile __dirname+'/reports/lint.txt', report, ->
        done()

