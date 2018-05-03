require 'net/http' # Require Net::HTTP lib which is part of the Ruby standard library

# ENVIRONMENT VARIABLES - to set your env vars on Mac OS X, run the export command below:
# $ export UN='INSERT-USERNAME' PW='INSERT-PASSWORD' ACCOUNT='INSERT-ACCOUNT-NAME'
username = ENV['UN']
password = ENV['PW']
account_name = ENV['ACCOUNT']

# LOCAL VARIABLES - alternative to env vars, simply uncomment and assign your creds directly below:
# username = 'INSERT-USERNAME'
# password = 'INSERT-PASSWORD'
# account_name = 'INSERT-ACCOUNT-NAME'

# Value provided at the end of the 'jobURL' in the response payload upon creating a job. 
job_uuid = "INSERT-JOB-UUID" # example uuid: eky8nws010

# --- No input required below this point ---

# Constructs your Job endpoint URI using job_uuid and account_name variables assigned above
uri = URI("https://gnip-api.gnip.com/historical/powertrack/accounts/#{account_name}/publishers/twitter/jobs/#{job_uuid}.json")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8'}
request = Net::HTTP::Get.new(uri, headers)
request.basic_auth(username, password)

begin
    response = http.request(request)
rescue
    sleep 5
    response = http.request(request) #try again
end

puts response.body