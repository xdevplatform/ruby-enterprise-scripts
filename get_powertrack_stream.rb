require 'net/http'

# To Run: $ ruby get_powertrack_stream.rb
# Pipe data to a file: $ ruby get_powertrack_stream.rb > ~/some-dir/<name-of-file>.txt

# Set to read environment variables. To set your env vars on Mac OS X run:
# $ export UN='INSERT-USERNAME'
# $ export PW='INSERT-PASSWORD'
# $ export UN='INSERT-ACCOUNT-NAME'
username = ENV['UN']
password = ENV['PW']
account_name = ENV['ACCOUNT']

# Alternatively, you can uncomment and assign your creds directly to the UN, PW, and account_name variables below
# UN = 'INSERT-USERNAME'
# PW = 'INSERT-PASSWORD'
# account_name = 'INSERT-ACCOUNT-NAME'

stream_label = 'prod' # Use the label found at the end of your stream endpoint (e.g., prod, dev, etc.)

# Your stream URL will be constructed based on the variables entered above 
stream_url = "https://gnip-stream.twitter.com/stream/powertrack/accounts/#{account_name}/publishers/twitter/#{stream_label}.json"
uri = URI(stream_url)

# A ruby hash specifying the proper headers for the GET request to the stream endpoint
# NOTE: The Net::HTTP lib automatically adds Accept-Encoding for compression of response bodies and automatically decompresses gzip and deflate responses.
# You may need to specify 'Accept-Encoding: gzip' header if you're using a different HTTP lib.
headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8', 'Connection' => 'keep-alive'}

# ::start immediately creates a connection to an HTTP server which is kept open for the duration of the block
Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  request = Net::HTTP::Get.new(uri, headers)
  request.basic_auth(username, password)
  # Puts request headers for debugging/informational purposes (you may comment this block out)
  request.each_header do |header_name, header_value|
    puts "#{header_name} : #{header_value}"
  end
  http.request(request) do |response|
    # Puts HTTP response code and message for debugging/informational purposes
    puts "---- \nHTTP response: #{response.code} - #{response.message} \n----"
    # read_body provides the response body in fragments (when passed to a block) as it is read in from the socket.
    response.read_body do |chunk| # 'chunk' size is inherent to ready_body method and does not represent full Tweet objects
      puts chunk
    end
  end
end