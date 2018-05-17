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

# Enter your endpoint label below (most likely "prod") and product archive access
endpoint_label = "dev" # Use the label found at the end of your stream endpoint (e.g., prod, dev, etc.)
archive = "fullarchive" # May be '30day' or 'fullarchive'

# Constructs your Search endpoint URI using variables assigned above
uri = URI("https://gnip-api.twitter.com/search/#{archive}/accounts/#{account_name}/#{endpoint_label}.json")

# Enter your Search parameters below:
rule = "from:twitterdev OR @twitterdev" # required
from_date = "201803010000" # optional (date must be in the format: YYYYMMDDHHMM)
to_date = "201803312359" # optional (date must be in the format: YYYYMMDDHHMM)
max_results = 500 # optional. Accepts an integer (10-500). Defaults is 100.

# --- No input required below this point ---

query = { :query => rule, :fromDate => from_date, :toDate => to_date, :maxResults => max_results }
json_request_body = query.to_json

headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8'}

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri, headers)
request.basic_auth(username, password)
request.body = json_request_body

# make the first request
puts "Making Search request... #{json_request_body}"
first_response = http.request(request)
# JSON parse the first response body
first_response = JSON.parse(first_response.body)
puts first_response.to_json, "\n"

total_count = first_response['results'].length

# Check to see if 'next' token is returned in first response
if first_response['next'].nil?
	puts "No pagination required. Request complete.", "Total count: #{total_count}"
else
	# Make another request with next token (begin loop)
	next_token = first_response['next']
	request_count = 1
	while !next_token.nil? do
		# Add 'next' param to query hash
		query[:next] = next_token
		# Convert request to valid json body
		json_request_body = query.to_json
		request.body = json_request_body
		# Make request
		response = http.request(request)
		n_response = JSON.parse(response.body)
		puts n_response, "\n"
		next_token = n_response['next']
		# iterate request_count and total_count
		request_count += 1
		total_count += n_response['results'].length
	end
	puts "Done paginating. Request complete."
	puts "Total count: #{total_count}", "Total requests: #{request_count}"
end
