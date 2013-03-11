module.exports = class Router

  #modules
  fs: require 'fs'
  coffeelint: require 'coffeelint'
  kss: require 'kss'
  jade: require 'jade'
  #parallel: require('async').parallel

  path:
    dist:
      js: "#{glob.root}/dist/#{glob.config.name}.js"
      css: "#{glob.root}/dist/#{glob.config.name}.css"

  dist:
    js: ''
    css: ''

  init: (app,cb)->
    app.get '/', @root
    app.get '/pid', @pid
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

  pid: (req,res)=>
    if req.query.secret is @config.secret
      res.send
        pid: process.pid
    else
      res.send 401

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

  test: (req,res)=>
    errors = {}
    pathes = {}

    path = "#{__dirname}/../src/coffee/"
    files = @fs.readdirSync path
    for f in files
      contents = @fs.readFileSync path + f, 'utf-8'
      errors[f] = @coffeelint.lint contents

    path2="#{__dirname}/../examples/public/coffee/"
    files2 = @fs.readdirSync path2
    for t in files2
      contents = @fs.readFileSync path2 + t, 'utf-8'
      errors[t] = @coffeelint.lint contents

    path3="#{__dirname}/../server/"
    files3 = @fs.readdirSync path3
    for d in files3
      if d.substr(-7) is ".coffee"
        contents = @fs.readFileSync path3 + d, 'utf-8'
        errors[d] = @coffeelint.lint contents

    try
      lint = @fs.readFileSync __dirname+'/../test/reports/lint.txt'

    res.render 'test'
      errors: errors
      page: 'mocha'
      lint: lint
      app_name: glob.config.name

  coverage: (req,res)=>
    cover = {}
    coverPath = "#{glob.config.path.jscoverage.coverage_reports}/unit.html"
    htmlBody = @fs.readFileSync coverPath, 'utf-8'
    start = htmlBody.indexOf("<body>")+6
    end = htmlBody.indexOf("</body></html>")
    testText = htmlBody.substr(start, end)
    #console.log testText

    cover = testText

    res.render 'coverage'
      cover: cover
      page: 'coverage'
      app_name: glob.config.name

    #report = ''
    #try
      #destDir = __dirname+'/../test/reports/coverage.html'
      #report = glob.@fs.readFileSync destDir
    #res.setHeader 'Content-Type', 'text/html'
    #res.setHeader 'Content-Length', report.length
    #res.end report

  styleguide: (req,res)=>
    options =
      markdown: false
    @kss.traverse "#{__dirname}/../src/", options, (err, styleguide)=>
      @getSections styleguide.section(), (sections)=>
        res.render 'styleguide'
          sections: sections
          page: 'styleguide'
          app_name: glob.config.name

  getSections: (sections, cb) ->
    jadeDir = "#{__dirname}/../examples/views/sections/"
    for section in sections
      section.data.filename = 'tables.scss'
      section.data.description = section.data.description
        .replace(/\n/g, "<br />")
      jade = null
      try
        jadePath = "#{jadeDir}#{section.reference()}.jade"
        jade = @fs.readFileSync jadePath
      if jade
        locals =
          section: section
          className: '$modifier'
        html = @jade.compile(jade, {pretty: true})(locals)
        section.data.example = html
        for modifier in section.modifiers()
          a = {className: modifier.className()}
          modifier.data.example = @jade.compile(
            jade,
            {pretty: true}
          )(a)
    cb sections if cb

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
