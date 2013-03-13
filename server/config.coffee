module.exports = config = {}

config.name = name = 'showcase'
config.root = root = "#{__dirname}/.."

#____________________________________server____________________________________#
config.server =
  secret: 'secretstring'
  port: process.env.PORT or 5000
  css_engine: 'scss'

#____________________________________watch_____________________________________#
config.watch =
  dirs: [
    "#{root}/server"
    "#{root}/src"
    "#{root}/test"
    "#{root}/examples/public/coffee"
    "#{root}/examples/views"
    "#{root}/examples/public/libs"
  ]
  files: [
    "#{root}/start.js"
  ]

#____________________________________lint_____________________________________#
config.lint = [
  "#{root}/src/coffee"
  "#{root}/server"
  "#{root}/examples/public/coffee"
]

#____________________________________path_____________________________________#
config.path =
  temp: temp = "#{root}/temp"
  views: "#{root}/examples/views"
  public: "#{root}/examples/public"
  dist: "#{root}/dist"
  runners:
    start: "#{root}/server/runners/start.js"
  test_runners:
    cover_unit: "#{root}/server/runners/cover_unit"
    cover_integration: "#{root}/server/runners/cover_integration"
    spec: "#{root}/server/runners/spec",

#________________________jscoverage___________________________#
config.path.jscoverage =
  src: "#{root}/dist/#{name}.js"
  cov: cov = "#{temp}/cov"
  coverage_reports: coverage_reports = "#{root}/temp/coverage_reports"

config.path.jscoverage.jscov =
  unit: "#{cov}/unit_#{name}.js"
  integration: "#{cov}/integration_#{name}.js"

config.path.jscoverage.html_cov =
  unit: "#{coverage_reports}/unit.html"
  integration: "#{coverage_reports}/integration.html"

#________________________coffee_______________________________#
config.path.coffee =
  src:
    from: "#{root}/src/coffee/"
    to: "#{root}/dist/#{name}.js"
  test:
    from: "#{root}/test/unit/*_test.coffee"
    to: "#{root}/examples/public/js/test.js"
  examples:
    from: "#{root}/examples/public/coffee/"
    to: "#{root}/examples/public/js/"

#________________________docco_______________________________#
config.path.docco =
  #TODO subfolders
  from: "#{root}/src/coffee/*.coffee"
  to: "#{root}/examples/public/docs/"

#_________________________css________________________________#
config.path.css =
  src:
    include_paths: [ "#{root}/src/scss/"]
    from: "#{root}/src/scss/#{name}.scss"
    to: "#{root}/dist/#{name}.css"
  #TODO
  #examples:
    #from: null
    #to: null

#____________________________________bin_____________________________________#
config.bin =
  jscov: "#{root}/node_modules/jscoverage/bin/jscoverage"
  mocha: "#{root}/node_modules/mocha/bin/mocha"
  coffee: "#{root}/node_modules/coffee-script/bin/coffee"
  #docco: "#{root}/libs/docco/bin/docco"
  docco: "#{root}/server/libs/docco/bin/docco"
