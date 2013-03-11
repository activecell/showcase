config =
  name: 'showcase'
  secret: 'secretstring'
  port: process.env.PORT or 5000
  css_engine: 'scss'
  path:
    temp: "#{__dirname}/../temp"
    coverage_reports: "#{__dirname}/../temp/coverage_reports"

if process.env.NODE_ENV is 'testing'
  config.port = 5001
if process.env.REPORT
  config.port = 5002

module.exports = config
