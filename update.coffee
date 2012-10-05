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
  # PointHQ Email / API key
  email: ''
  key: ''
  # Your Zone ID
  zone: 1
  # Your Record ID
  record: 1
  # Service to get public IP
  public_ip_url: 'http://icanhazip.com' 
  # Don't touch!
  api_endpoint: 'pointhq.com'           

# Headers to specify JSON interaction
HEADERS =
  'Accept': 'application/json'
  'Content-type': 'application/json'

# The data we're sending to the API
data = 
  zone_record:
    data: null # We only wanna change the IP address

# The request options (see pointhq CONFIG)
options =
  method: 'PUT'
  host: "#{CONFIG.api_endpoint}"
  port: 80
  headers: HEADERS
  path: "/zones/#{CONFIG.zone}/records/#{CONFIG.record}"
  auth: "#{CONFIG.email}:#{CONFIG.key}"

# Getting our public IP through CONFIG.public_ip_url
ip_request = http.get CONFIG.public_ip_url, (response) ->
  response.setEncoding 'utf8' 
  response.on 'data', (body) ->
    # Set the IP on the data we're sending
    data.zone_record.data = body

    # Write the data and update the record
    request.write JSON.stringify data
    request.end()
.on 'error', (error) ->
  # If cant get the public ip we've nothing to do here
  console.log 'Cant get public IP!'
  process.exit()

# Request handler to the PointHQ API
request = http.request options, (response) ->
  # So... everything went just fine?? :D
  if response.statusCode == 201 # Docs says its 200 but never got that response!
    console.log "Updated to: #{data.zone_record.data}"

# Error handler
request.on 'error', (event) ->
  console.log "Request error: #{event.message}"
