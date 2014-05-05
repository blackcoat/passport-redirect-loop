restify  = require 'restify'
passport = require 'passport'
FacebookStrategy = require('passport-facebook').Strategy

passport.use new FacebookStrategy
  clientID:     process.env.FACEBOOK_APP_ID
  clientSecret: process.env.FACEBOOK_APP_SECRET
  callbackURL:  process.env.FACEBOOK_AUTH_REDIRECT_URL  # http://0.0.0.0:5000/auth/facebook/callback
  (accessToken, refreshToken, profile, done) ->
    user =
      name:  profile.displayName
      email: profile.emails[0]
    done null, user


server = restify.createServer()
server.use passport.initialize()

# Redirect the user to Facebook for authentication.  When complete,
# Facebook will redirect the user back to the application at
#     /auth/facebook/callback
server.get '/auth/facebook', passport.authenticate 'facebook',
  session: false
  scope: 'read_stream'

# Facebook will redirect the user to this URL after approval.  Finish the
# authentication process by attempting to obtain an access token.  If
# access was granted, the user will be logged in.  Otherwise,
# authentication has failed.
server.get '/auth/facebook/callback',
  passport.authenticate 'facebook',
    session: false
    successRedirect: '/success'  # Success redirect never happens...
    failureRedirect: '/failure'  # Nor does the failure redirect

server.get '/success', (req, res, err) ->
  res.send 'Success!'
  next()

server.get '/failure', (req, res, err) ->
  res.send 'Failed :('
  next()

server.listen Number(process.env.PORT), ->
  console.log '%s listening at %s', server.name, server.url


process.on 'SIGINT',  -> process.exit 0
process.on 'SIGTERM', -> process.exit 0
