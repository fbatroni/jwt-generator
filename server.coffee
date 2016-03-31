express = require('express')
request = require('request')
bodyParser = require('body-parser')
jwt = require('jsonwebtoken')
winston = require('winston')
port = process.env.PORT
secret = process.env.JWT_SECRET
app = express()
util = require 'util'

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
app.all '*', (req, res) ->
      tokenStuff = {}
      tokenStuff[name] = req.body[name] for name in req.body
      console.log util.inspect(tokenStuff)
      signingParams = { algorithm: 'HS256', expiresIn: tokenStuff.expiration ? '6h'}
      jwt.sign tokenStuff, secret, signingParams, (new_jwt) ->
        res.set('content-type','application/json').send(JSON.stringify(jwt: new_jwt))


server = app.listen(port, ->
  host = server.address().address
  port = server.address().port
  log.info 'glg-jwt-auth listening at http://%s:%s', host, port
)
