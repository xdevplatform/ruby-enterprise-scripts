# Copyright 2018 Twitter, Inc.
# Licensed under the MIT License
# https://opensource.org/licenses/MIT

require 'net/http' # Require Net::HTTP lib which is part of the Ruby standard library
require 'json'

# ENVIRONMENT VARIABLES - to set your env vars on Mac OS X, run the export command below:
# $ export UN='INSERT-USERNAME' PW='INSERT-PASSWORD' ACCOUNT='INSERT-ACCOUNT-NAME'
username = ENV['UN']
password = ENV['PW']
account_name = ENV['ACCOUNT']

# LOCAL VARIABLES - alternative to env vars, simply uncomment and assign your creds directly below:
# username = 'INSERT-USERNAME'
# password = 'INSERT-PASSWORD'
# account_name = 'INSERT-ACCOUNT-NAME'

# Constructs your Historical endpoint URI using account_name variable from above
uri = URI("https://gnip-api.gnip.com/historical/powertrack/accounts/#{account_name}/publishers/twitter/jobs.json")

# Enter job details below:
data_format = "original" # required.
from_date = "201803010000" # optional (date must be in the format: YYYYMMDDHHMM)
to_date = "201804010000" # optional (date must be in the format: YYYYMMDDHHMM)
title = "twitterdev-job" # required. Must be unique to other jobs created by your account.
# Two rules are used below for example sake. Each job can contain up to 1,000 rules.
rules =[ {"value": "from:twitterdev OR @twitterdev", "tag": "variation_01"}, {"value": "#twitterdev OR \"twitter dev\"", "tag": "variation_02" } ]

# --- No input required below this point ---

# Generates valid request hash
request = { :publisher => "twitter", :streamType => "track_v2", :dataFormat => data_format, :fromDate => from_date, :toDate => to_date, :title => title, :rules => rules}
# Converts request body from ruby hash to JSON
json_request_body = request.to_json

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8'}
request = Net::HTTP::Post.new(uri, headers)
request.basic_auth(username, password)
request.body = json_request_body

begin
    response = http.request(request)
rescue
    sleep 5
    response = http.request(request) #try again
end
# Puts response HTTP code, message, and body for verbosity
puts response.code, response.message, response.body