module.exports = class Router

  #modules
  fs: require 'fs'
  coffeelint: require 'coffeelint'
  kss: require 'kss'
  #parallel: require('async').parallel

  utils: new (require './utils')

  path:
    dist:
      js: "#{glob.config.root}/dist/#{glob.config.name}.js"
      css: "#{glob.config.root}/dist/#{glob.config.name}.css"

  dist:
    js: ''
    css: ''

  init: (app,cb)->
    app.get '/', @root
    app.get '/documentation', @documentation
    app.get '/test', @test
    app.get '/coverage', @coverage
    app.get '/styleguide', @styleguide
    app.get '/performance', @performance
    app.get "/js/#{glob.config.name}.js", @get_dist_js
    app.get "/css/#{glob.config.name}.css", @get_dist_css
    @fs.readFile @path.dist.js, (err,js)=>
      @dist.js = js.toString()
      cb() if @dist.css and cb
    @fs.readFile @path.dist.css, (err,css)=>
      @dist.css = css.toString()
      cb() if @dist.js and cb

  root: (req,res)=>
    res.render 'index'
      page: 'index'
      app_name: glob.config.name

  documentation: (req,res)=>
    docs = {}
    docsPath = "#{__dirname}/../examples/public/docs/"
    docFiles = @fs.readdirSync docsPath
    for docFile in docFiles
      if docFile.substr(docFile.length-4) == 'html'
        htmlBody = @fs.readFileSync docsPath + docFile, 'utf-8'
        jsReg = /<body>([\s\S]*?)<\/body>/gi
        container = jsReg.exec(htmlBody)
        docs[docFile] = container[1]
    res.render 'documentation'
      docs: docs
      page: 'documentation'
      app_name: glob.config.name

  #FIXME
  test: (req,res)=>
    res.render 'test'
      errors: glob.server.lint_errors
      page: 'mocha'
      app_name: glob.config.name

  coverage: (req,res)=>
    coverPath = "#{glob.config.path.jscoverage.coverage_reports}/unit.html"

    res.render 'coverage'
      cover: @fs.readFileSync(coverPath, 'utf-8')
      page: 'coverage'
      app_name: glob.config.name

  styleguide: (req,res)=>
    options =
      markdown: false
    @kss.traverse "#{__dirname}/../src/", options, (err, styleguide)=>
      @utils.getSections styleguide.section(), (sections)=>
        res.render 'styleguide'
          sections: sections
          page: 'styleguide'
          app_name: glob.config.name

  performance: (req,res)=>
    res.render 'performance'
      page: 'performance'
      app_name: glob.config.name

  get_dist_js: (req,res)=>
    res.setHeader 'Content-Type', 'text/javascript'
    res.setHeader 'Content-Length', @dist.js.length
    res.end @dist.js

  get_dist_css: (req,res)=>
    res.setHeader 'Content-Type', 'text/css'
    res.setHeader 'Content-Length', @dist.css.length
    res.end @dist.css
