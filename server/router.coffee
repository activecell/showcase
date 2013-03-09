module.exports = class Router

  #modules
  fs: require 'fs'
  coffeelint: require 'coffeelint'
  kss: require 'kss'
  jade: require 'jade'

  config: require './config'

  constructor: (options) ->
    @[o] = options[o] for o of options
    @dist_js = @fs.readFileSync "#{__dirname}/../dist/#{name}.js"
    @dist_css = @fs.readFileSync "#{__dirname}/../dist/#{name}.css"

  bindRoutes: (app)->
    app.get '/', @root
    app.get '/pid', @pid
    app.get '/documentation', @documentation
    app.get '/test', @test
    app.get '/coverage', @coverage
    app.get '/styleguide', @styleguide
    app.get '/performance', @perfomance
    app.get "/js/#{name}.js", @get_dist_js
    app.get "/css/#{name}.css", @get_dist_css

  root: (req,res)=>
    res.render 'index'
      page: 'index'

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

  coverage: (req,res)=>
    cover = {}
    coverPath = "#{__dirname}/../test/reports/coverage.html"
    htmlBody = @fs.readFileSync coverPath, 'utf-8'
    start = htmlBody.indexOf("<body>")+6
    end = htmlBody.indexOf("</body></html>")
    testText = htmlBody.substr(start, end)
    #console.log testText

    cover = testText

    res.render 'coverage'
      cover: cover
      page: 'coverage'

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

  getSections: (sections, cb) ->
    jadeDir = "#{__dirname}/../examples/views/sections/"
    for section in sections
      section.data.filename = 'tables.scss'
      section.data.description = section.data.description.replace(/\n/g, "<br />")
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

  get_dist_js: (req,res)=>
    res.setHeader 'Content-Type', 'text/javascript'
    res.setHeader 'Content-Length', script.length
    res.end @dist_js

  get_dist_css: (req,res)=>
    res.setHeader 'Content-Type', 'text/css'
    res.setHeader 'Content-Length', style.length
    res.end @dist_css
