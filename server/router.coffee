module.exports = class Router
  fs: require 'fs'

  constructor: (options) ->
    @[o] = options[o] for o of options

  bindRoutes: (app)->
    app.get '/', @root
    app.get '/pid', @pid
    app.get '/documentation', @documentation
    app.get '/test', @test
    app.get '/coverage', @coverage
    app.get '/styleguide', @styleguide
    app.get '/performance', @perfomance
    app.get "/js/#{name}.js", @dist_js
    app.get "/css/#{name}.css", @dist_css

  root: (req,res)=>
    res.render 'index'
      page: 'index'

  pid: (req,res)=>
    if req.query.secret is glob.config.secret
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
      errors[f] = @modules.coffeelint.lint contents

    path2="#{__dirname}/../examples/public/coffee/"
    files2 = @fs.readdirSync path2
    for t in files2
      contents = @fs.readFileSync path2 + t, 'utf-8'
      errors[t] = @modules.coffeelint.lint contents

    path3="#{__dirname}/../server/"
    files3 = @fs.readdirSync path3
    for d in files3
      if d.substr(-7) is ".coffee"
        contents = @fs.readFileSync path3 + d, 'utf-8'
        errors[d] = @modules.coffeelint.lint contents

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
    modules.kss.traverse "#{__dirname}/../src/", options, (err, styleguide)->
      glob.getSections styleguide.section(), (sections)->
        res.render 'styleguide'
          sections: sections
          page: 'styleguide'

  performance: (req,res)=>
    res.render 'performance'
      page: 'performance'

  dist_js: (req,res)=>
    script = @fs.readFileSync "#{__dirname}/../dist/#{name}.js"
    res.setHeader 'Content-Type', 'text/javascript'
    res.setHeader 'Content-Length', script.length
    res.end script

  dist_css: (req,res)=>
    style = @fs.readFileSync "#{__dirname}/../dist/#{name}.css"
    res.setHeader 'Content-Type', 'text/css'
    res.setHeader 'Content-Length', style.length
    res.end style
