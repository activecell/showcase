describe 'server', ->

  it "test #{glob.url}", (done) ->
    glob.request.get glob.url, (err,res,body) ->
      assert body
      done()

  it "test #{glob.url}documentation", (done) ->
    glob.request.get glob.url+"documentation", (err,res,body) ->
      assert body
      done()

  it "test #{glob.url}test", (done)->
    glob.request.get glob.url+"test", (err,res,body) ->
      assert body
      done()

  it "test #{glob.url}styleguide", (done) ->
    glob.request.get glob.url+"styleguide", (err,res,body) ->
      assert body
      done()

