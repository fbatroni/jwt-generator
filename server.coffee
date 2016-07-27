express = require('express')
bodyParser = require('body-parser')
winston = require('winston')
glgutil = require('glg-jwt').glgutil
port = process.env.PORT
epiUrl = process.env.EPI_AUTH_TEMPLATE
app = express()

winston.setLevels winston.config.syslog.levels
log = new (winston.Logger)(transports: [ new (winston.transports.Console)(
  level: 'info'
  timestamp: true) ])

app.use bodyParser.urlencoded(extended: true)

# route "/healthy"
app.get '/healthy', (req, res) ->
  res.status 200
  res.send()
  return

# route "/generate": generates jwt token
app.all '/generate', (req, res) ->
  sendResponse = getSendResponse(res)
  glgutil.getUsersPayload(req.body.email ? req.query.email,'',req.body.expiration ? req.query.expiration ? '6h')
    .then (usersPayload) ->
      log.info "got usersPayload: #{usersPayload}"
      sendResponse jwt: usersPayload.token
    .catch (err) ->
      log.err "#{err}"
      sendResponse error: "Error getting usersPayload, using #{epiUrl} Error Details: #{err}"

getSendResponse = (res) ->
  (res_body) ->
    log.info "sending response: #{res_body}"
    res.writeHead 200, 'Content-Type': 'application/json'
    res.write JSON.stringify(res_body)
    res.send()

server = app.listen(port, ->
  host = server.address().address
  port = server.address().port
  log.info "jwt-generator listening at http://#{host}:#{port} using epi: #{epiUrl}"
)
