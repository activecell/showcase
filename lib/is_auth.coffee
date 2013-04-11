module.exports = (req, res, next) ->
  return next() unless req.app.get('github-client-id') && req.app.get('github-client-secret')
  return next() if req.isAuthenticated()
  res.redirect('/login')
