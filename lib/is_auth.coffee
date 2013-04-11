module.exports = (req, res, next) ->
  return next() unless app.get('github-client-id') && app.get('github-client-secret')
  return next() if req.isAuthenticated()
  res.redirect('/login')
