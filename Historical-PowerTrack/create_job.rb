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
from_date = "201803152338" # optional (date must be in the format: YYYYMMDDHHMM)
to_date = "201804131644" # optional (date must be in the format: YYYYMMDDHHMM)
title = "job-01" # required. Must be unique to other jobs created by your account.
rules =[ {"value": "from:twitterdev", "tag": "twitterdev"}, {"value": "from:twitter", "tag": "twitter" } ]

request = { :publisher => "twitter", :streamType => "track_v2", :dataFormat => data_format, :fromDate => from_date, :toDate => to_date, :title => title, :rules => rules}
json_request_body = request.to_json

headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8'}

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri, headers)
request.basic_auth(username, password)
request.body = json_request_body

begin
    response = http.request(request)
rescue
    sleep 5
    response = http.request(request) #try again
end

puts response.code, response.message, response.body