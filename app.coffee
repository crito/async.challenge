express = require('express')
http    = require('http')
path    = require('path')

app     = express()
server  = require('http').createServer(app)

# When true, do a graceful shutdown by refusing new incoming request.
gracefullyClosing = false

# Configure our node app for all environments
app.set 'port', process.env.PORT or 5000
app.use express.favicon()
app.use express.logger('short')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))
app.use (req, res, next) ->
  return next() unless gracefullyClosing
  res.setHeader "Connection", "close"
  res.send 502, "Server is in the process of restarting"

app.configure 'development', ->
  app.use express.errorHandler()

app.configure 'staging', ->
app.configure 'development', ->

# Set up our routes
require('./routes')(app)

# Lets start our HTTP server and listen on our specified port
httpServer = server.listen app.get('port')

# Gracefully shutdown on SIGTERM
# Note: This might not work very well with websockets, in that case close
# those connections manually and retry on the client.
process.on 'SIGTERM', ->
  gracefullyClosing = true
  console.log "Received kill signal (SIGTERM), shutting down gracefully."
  # Wait for existing connections to close, and exit the process
  httpServer.close ->
    console.log "Closed out remaining connections."
    process.exit()

  # Our patience to wait has a limit
  setTimeout ->
    console.error "Could not close connections in time, forcefully shutting down"
    process.exit(1)
  , 30*1000
