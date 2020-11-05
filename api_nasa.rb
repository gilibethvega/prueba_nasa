require 'uri'
require 'net/http'
require 'json'

def request(url, api_key)
  url_concat = url + "&api_key=" + api_key
  url = URI(url_concat)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'
  response = http.request(request)
  return JSON.parse(response.body)
end

data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=1', 'NuBlb8sZRP2vrbWW2X4oPqDcw6wV2DpgWmltScu6')



photos = data['photos']

puts "<ul>"
photos.each do |photo|
  puts "\t<li><img src=#{photo["img_src"]}></li>"
end
puts "</ul>"



