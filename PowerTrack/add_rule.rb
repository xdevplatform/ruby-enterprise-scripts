require "net/http" # Require Net::HTTP lib which is part of the Ruby standard library

# ENVIRONMENT VARIABLES - to set your env vars on Mac OS X, run the export command below:
# $ export UN='INSERT-USERNAME' PW='INSERT-PASSWORD' ACCOUNT='INSERT-ACCOUNT-NAME'
username = ENV['UN']
password = ENV['PW']
account_name = ENV['ACCOUNT']

# LOCAL VARIABLES - alternative to env vars, simply uncomment and assign your creds directly below:
# username = 'INSERT-USERNAME'
# password = 'INSERT-PASSWORD'
# account_name = 'INSERT-ACCOUNT-NAME'

stream_label = "prod" # Use the label found at the end of your stream endpoint (e.g., prod, dev, etc.)

# Your stream URL will be constructed based on the variables entered above 
rules_url = "https://gnip-api.twitter.com/rules/powertrack/accounts/#{account_name}/publishers/twitter/#{stream_label}.json"

rule_value = "(\\\"steve brule\\\")"
rule_tag = "brule"
rules_json = "{\"rules\":[{\"value\":\"" + rule_value + "\",\"tag\":\"" + rule_tag + "\"}]}"

headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8'}

uri = URI(rules_url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri, headers)
request.body = rules_json
request.basic_auth(username, password)

begin
    response = http.request(request)
rescue
    sleep 5
    response = http.request(request) #try again
end

puts response.body