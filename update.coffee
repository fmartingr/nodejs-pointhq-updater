###
NodeJS PointHQ A Record updater
Felipe "Pyron" Martín
me@fmartingr.com

Simple script that updates the A record from a custom entry in
the pointHQ service.

API Doc: http://support.pointhq.com/kb/api-documentation/zone-records
###

# Libraries
http = require 'http'

# Configuration
CONFIG =
  email: ''                 # PointHQ Email
  key: ''                   # PointHQ API Key
  zone: 1                   # Your Zone ID
  record: 1                 # Your Record ID
  endpoint: 'pointhq.com'   # Don't touch!

# Headers to specify JSON interaction
HEADERS =
  'Accept': 'application/json'
  'Content-type': 'application/json'

# The request options (see pointhq CONFIG)
options =
  method: 'PUT'
  host: "#{CONFIG.endpoint}"
  port: 80
  headers: HEADERS
  path: "/zones/#{CONFIG.zone}/records/#{CONFIG.record}"
  auth: "#{CONFIG.email}:#{CONFIG.key}"

# The data we're sending to the API
data = 
  zone_record:
    data: '4.4.4.8' # We only wanna change the IP address

# Request handler
request = http.request options, (response) ->
  # So... everything went just fine?? :D
  if response.statusCode == 201 # Docs says its 200 but never got that response!
    console.log "Updated to: #{data.zone_record.data}"

  # Some debug rubbish
  #response.on 'data', (chunk) ->
  #  console.log "CHUNK: #{chunk}"

# Error handler
request.on 'error', (event) ->
  console.log "Request error: #{event.message}"

# Write the data and update the record
request.write JSON.stringify data
request.end()
