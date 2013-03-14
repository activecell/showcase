# https://github.com/jaredhanson/passport-github/tree/master/examples/login
passport             = require('passport')
GitHubStrategy       = require('passport-github').Strategy
GITHUB_CLIENT_ID     = '8c303a4bd7db8d5da8b5'
GITHUB_CLIENT_SECRET = '1b72ccdcf3c24ac6ecc9ad7537636ec57d0997b3'

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
  clientSecret: GITHUB_CLIENT_SECRET,
  callbackURL: '/auth/github/callback'
}, (accessToken, refreshToken, profile, done) ->
  # asynchronous verification, for effect...
  process.nextTick ->
    # To keep the example simple, the user's GitHub profile is returned to
    # represent the logged-in user.  In a typical application, you would want
    # to associate the GitHub account with a user record in your database,
    # and return that user instead.
    done(null, profile)

module.exports = passport
