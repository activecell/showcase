isAuth = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/login')

module.exports = (app, passport) ->
  # GET /auth/github
  #   Use passport.authenticate() as route middleware to authenticate the
  #   request.  The first step in GitHub authentication will involve redirecting
  #   the user to github.com.  After authorization, GitHubwill redirect the user
  #   back to this application at /auth/github/callback
  app.get '/auth/github', passport.authenticate('github')

  # GET /auth/github/callback
  #   Use passport.authenticate() as route middleware to authenticate the
  #   request.  If authentication fails, the user will be redirected back to the
  #   login page.  Otherwise, the primary route function function will be called,
  #   which, in this example, will redirect the user to the home page.
  app.get '/auth/github/callback', passport.authenticate('github', { failureRedirect: '/login' }), (req, res) {
    res.redirect('/')

  app.get '/login', (req, res) ->
    res.send(200, '<a href="/auth/github">Login</a>')

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect('/')

  app.all '*', isAuth
