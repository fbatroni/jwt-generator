express = require('express')
request = require('request')
bodyParser = require('body-parser')
jwt = require('jsonwebtoken')
winston = require('winston')
local_epi = process.env.LOCAL_EPIQUERY
port = process.env.PORT
secret = process.env.JWT_SECRET
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

# route "/submit": Validate and handle form submission
app.all '/generate', (req, res) ->
  epiUrl = local_epi + 'epiquery1/glglive/glg-auth/authenticate.mustache'
  # call epiquery to validate user email
  request.post epiUrl, { form: email: req.body.email ? req.query.email }, (err, httpResponse, body) ->
    sendResponse = getSendResponse(res)
    if err?
      sendResponse error: "Error posting to epiquery: #{err}"
      return
    try
      parsedBody = JSON.parse(body)
      # epi responded with an error
      if parsedBody?.error
        sendResponse error: "Error posting to epiquery: #{parsedBody.error}"
        return
      # epi responded with something utterly unexpected
      unless Array.isArray(parsedBody)
        sendResponse error: "Unexpected epi response: #{body}"
      # epi responded successfully
      output = parsedBody[0]
      unless output?.PERSON_ID?
        sendResponse error: "Missing PERSON_ID: #{body}"
        return
      # set roles based on IDs returned, For now, the only role we support is CM.
      jwt.sign {
        role: if output.COUNCIL_MEMBER_ID then 'cm' else ''
        personid: output.PERSON_ID
        cmid: output.COUNCIL_MEMBER_ID
      }, secret, {
        algorithm: 'HS256'
        expiresIn: '6h'
      }, (new_jwt) ->
        sendResponse jwt: new_jwt
    catch err
      sendResponse error: "Error parsing epistream response to #{epiUrl} Error Details: #{err}"

getSendResponse = (res) ->
  (res_body) ->
    res.writeHead 200, 'Content-Type': 'application/json'
    res.write JSON.stringify(res_body)
    res.send()

server = app.listen(port, ->
  host = server.address().address
  port = server.address().port
  log.info 'glg-jwt-auth listening at http://%s:%s using epi: %s', host, port, local_epi
)
