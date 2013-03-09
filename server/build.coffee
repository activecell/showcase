module.exports = class Build

  fs: require 'fs'

  #compilers
  css: require './compilers/css'
  docco: require './compilers/docco'
  jscoverage: require './compilers/jscoverage'
  coffee: require './compilers/coffee'
  lint: require './compilers/lint'

  #modules
  parallel: require('async').parallel

  constructor: (options) ->
    try
      @fs.mkdirSync glob.config.path.temp

    @build =
      step1: [
        @coffee.compile.src
        @coffee.compile.examples
        @coffee.compile.tests
        @lint.compile
        @css.compile
      ]
      step2: [
        @docco.compile
        @jscoverage.compile.unit
        @jscoverage.compile.integration
      ]
      step3: [
        @jscoverage.report.unit
        @jscoverage.report.integration
      ]

  start: (cb1,cb2,cb3) ->
    @parallel @build.step1, =>
      cb1() if cb1
      @parallel @build.step2, =>
        cb2() if cb2
        @parallel @build.step3, =>
          cb3() if cb3
