module.exports = class Build

  fs: require 'fs'

  #compilers
  coffee: new (require './compilers/coffee')
  css: new (require './compilers/css')
  docco: new (require './compilers/docco')
  jscoverage: new (require './compilers/jscoverage')
  lint: new (require './compilers/lint')
  test: new (require './compilers/test')

  #modules
  parallel: require('async').parallel

  constructor: (options) ->
    try
      @fs.mkdirSync glob.config.path.temp
      @fs.mkdirSync glob.config.path.dist
    @functions =
      compilers: [
        @coffee.compile_src
        @coffee.compile_examples
        @coffee.compile_tests
        @lint.compile
        @css.compile_src
        @docco.compile
      ]
      report: [
        @jscover
        @test_reports
      ]


  compile: (cb)->
    @parallel @functions.compilers, =>
      cb() if cb

  spec: (cb)->
    @test.spec =>
      cb() if cb

  test_reports: (cb)=>
    cb() if cb

  jscover: (cb)=>
    @jscoverage.run =>
      cb() if cb

  report: (cb)->
    @parallel @functions.report, =>
      cb() if cb
