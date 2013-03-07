name = glob.config.name
app = glob.app
modules = glob.modules

app.get '/pid', (req,res)->
  if req.query.secret is glob.config.secret
    res.send
      pid: process.pid
  else
    res.send 401

app.get '/', (req,res)->
  res.render 'index'
    page: 'index'

app.get '/documentation', (req,res)->
  docs = {}
  docsPath = "#{__dirname}/../examples/public/docs/"
  docFiles = modules.fs.readdirSync docsPath
  for docFile in docFiles
    if docFile.substr(docFile.length-4) == 'html'
      htmlBody = modules.fs.readFileSync docsPath + docFile, 'utf-8'
      jsReg = /<body>([\s\S]*?)<\/body>/gi
      container = jsReg.exec(htmlBody)
      docs[docFile] = container[1]

  res.render 'documentation'
    docs: docs
    page: 'documentation'

app.get '/test', (req,res)->
  errors = {}
  pathes = {}

  path = "#{__dirname}/../src/coffee/"
  files = modules.fs.readdirSync path
  for f in files
    contents = modules.fs.readFileSync path + f, 'utf-8'
    errors[f] = modules.coffeelint.lint contents

  path2="#{__dirname}/../examples/public/coffee/"
  files2 = modules.fs.readdirSync path2
  for t in files2
    contents = modules.fs.readFileSync path2 + t, 'utf-8'
    errors[t] = modules.coffeelint.lint contents

  path3="#{__dirname}/../server/"
  files3 = modules.fs.readdirSync path3
  for d in files3
    if d.substr(-7) is ".coffee"
      contents = modules.fs.readFileSync path3 + d, 'utf-8'
      errors[d] = modules.coffeelint.lint contents

  try
    lint = glob.modules.fs.readFileSync __dirname+'/../test/reports/lint.txt'

  res.render 'test'
    errors: errors
    page: 'mocha'
    lint: lint

app.get '/coverage', (req,res)->
  cover = {}
  coverPath = "#{__dirname}/../test/reports/coverage.html"
  htmlBody = modules.fs.readFileSync coverPath, 'utf-8'
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
    #report = glob.modules.fs.readFileSync destDir
  #res.setHeader 'Content-Type', 'text/html'
  #res.setHeader 'Content-Length', report.length
  #res.end report

app.get '/styleguide', (req,res)->
  options =
    markdown: false
  modules.kss.traverse "#{__dirname}/../src/", options, (err, styleguide)->
    glob.getSections styleguide.section(), (sections)->
      res.render 'styleguide'
        sections: sections
        page: 'styleguide'

app.get '/performance', (req,res)->
  res.render 'performance'
    page: 'performance'

app.get "/js/#{name}.js", (req,res)->
  script = modules.fs.readFileSync "#{__dirname}/../dist/#{name}.js"
  res.setHeader 'Content-Type', 'text/javascript'
  res.setHeader 'Content-Length', script.length
  res.end script

app.get "/css/#{name}.css", (req,res)->
  style = modules.fs.readFileSync "#{__dirname}/../dist/#{name}.css"
  res.setHeader 'Content-Type', 'text/css'
  res.setHeader 'Content-Length', style.length
  res.end style

