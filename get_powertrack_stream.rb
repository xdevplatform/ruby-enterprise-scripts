require 'net/http'

powertrack = 'https://gnip-stream.twitter.com/stream/powertrack/accounts/John-Demos/publishers/twitter/prod.json'
compliance = 'https://gnip-stream.twitter.com/stream/compliance/accounts/John-Demos/publishers/twitter/prod.json?partition=1'

UN = ENV['UN']
PW = ENV['PW']

uri = URI(powertrack)
headers = {'Accept' => '*/*', 'Content-Type' => 'application/json; charset=utf-8', 'Connection' => 'keep-alive'}

Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  request = Net::HTTP::Get.new(uri, headers)
  request.basic_auth(UN, PW)
  request.each_header do |header_name, header_value|
    puts "#{header_name} : #{header_value}"
  end
  http.request(request) do |response|
    # Echo HTTP response code and message
    puts "HTTP response: #{response.code} - #{response.message}"
    response.read_body do |chunk|
      puts chunk
    end
  end
end