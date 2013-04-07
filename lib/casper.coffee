{spawn, exec} = require('child_process')

prepareData = (data) ->
  data = data.toString()
  data.slice(0, data.lastIndexOf('\n'))

module.exports = ->
  exec 'lsof -i :5000', (err, stdout, stderr) ->
    if stdout.length is 0
      process.env.NODE_ENV = "test"
      require('../app')

    process.nextTick ->
      casperjs = spawn('casperjs', ['test'].concat(process.argv.slice(2)))

      casperjs.stdout.on 'data', (data) -> console.log prepareData(data)
      casperjs.stderr.on 'data', (data) -> console.log 'Error: ' + prepareData(data)

      casperjs.on 'exit', (code) ->
        process.exit()
