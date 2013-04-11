# https://github.com/jaredhanson/passport-github/tree/master/examples/login
GitHubStrategy = require('passport-github').Strategy

module.exports = (app, passport) ->
  GITHUB_CLIENT_ID     = app.get('github-client-id')
  GITHUB_CLIENT_SECRET = app.get('github-client-secret')

  # Passport session setup.
  #   To support persistent login sessions, Passport needs to be able to
  #   serialize users into and deserialize users out of the session.  Typically,
  #   this will be as simple as storing the user ID when serializing, and finding
  #   the user by ID when deserializing.  However, since this example does not
  #   have a database of user records, the complete GitHub profile is serialized
  #   and deserialized.
  passport.serializeUser  (user, done) -> done(null, user)
  passport.deserializeUser (obj, done) -> done(null, obj)

  # Use the GitHubStrategy within Passport.
  #   Strategies in Passport require a `verify` function, which accept
  #   credentials (in this case, an accessToken, refreshToken, and GitHub
  #   profile), and invoke a callback with a user object.
  passport.use new GitHubStrategy {
    clientID: GITHUB_CLIENT_ID,
    clientSecret: GITHUB_CLIENT_SECRET
  }, (accessToken, refreshToken, profile, done) ->
    # asynchronous verification, for effect...
    process.nextTick ->
      # To keep the example simple, the user's GitHub profile is returned to
      # represent the logged-in user.  In a typical application, you would want
      # to associate the GitHub account with a user record in your database,
      # and return that user instead.
      done(null, profile)

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
  app.get '/auth/github/callback', passport.authenticate('github', { failureRedirect: '/login' }), (req, res) ->
    res.redirect('/')

  app.get '/login', (req, res) ->
    res.send(200, '<a href="/auth/github">Login</a>')

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect('/')

  app.all '*', (req, res, next) ->
    return next() if req.isAuthenticated()
    res.redirect('/login')
