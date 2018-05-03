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

stream_label = "prod" # Use the label found at the end of your stream endpoint (e.g., prod, dev, etc.)

# --- No input required below this point ---

# Your stream URL will be constructed using your account_name and stream_label vars
stream_url = "https://gnip-stream.twitter.com/stream/sample10/accounts/#{account_name}/publishers/twitter/#{stream_label}.json"
# Create unique URLs for both partitions of the Decahose
partition1 = "#{stream_url}?partition=1"
partition2 = "#{stream_url}?partition=2"

# create an array of sites we wish to visit concurrently.
urls = [partition1, partition2]  
# Create an array to keep track of threads.
threads = []

headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8', 'Connection' => 'keep-alive'}

urls.each do |u|  
  # spawn a new thread for each url
  threads << Thread.new do
	  Net::HTTP.start(URI.parse(u).host, URI.parse(u).port, :use_ssl => true) do |http|
		  request = Net::HTTP::Get.new(URI.parse(u), headers)
		  request.basic_auth(username, password)
		  # Puts request headers for debugging/informational purposes (you may comment this block out)
		  puts "----"
		  request.each_header do |header_name, header_value|
		    puts "#{header_name} : #{header_value}"
		  end
		  http.request(request) do |response|
		    # Puts HTTP response code and message for debugging/informational purposes
		    puts "---- \nHTTP response: #{response.code} - #{response.message} \n----"
		    # read_body provides the response body in fragments (when passed to a block) as it is read in from the socket.
		    response.read_body do |chunk| # The chunk size is a static 16 KB (set by net http stdlib) and does not represent full Tweet objects
		      puts chunk
		    end
		  end
		end
	end
end

threads.each { |t| t.join }