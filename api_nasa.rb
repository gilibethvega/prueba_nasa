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

def build_web_page(data)
  photos = data['photos']
  begin_html = ["<html>","\t<head>","\t\t<title>Fotos Nasa | Prueba Gili :)</title>","\t</head>","\t<body>", "\t\t<h1>Desafío {APIs} by Gilibeth Vega</h1>","\t\t<ul style='list-style-type:none;'>"]
  final_html= ["\t\t</ul>", "\t</body>", "</html>"]
  middle = []
  half_html = []
  total_html = []
  photos.each do |photo|
    middle.push ("\t\t\t<li><img src=#{photo["img_src"]} width='500' height='200'></li>")
  end
  half_html = begin_html.push middle
  total_html = half_html.push final_html
  
  File.new("index.html", "w")
  File.write('index.html', total_html.join("\n"))
end

def photos_count(data)
  photos = data['photos']
    total = []
  photos.each do |photo|
    total.push photo["camera"]['name']
  end
  new_hash = total.group_by { |x| x }
  new_hash.each do |k,v|
    new_hash[k] = v.count
  end
end


data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=1', 'NuBlb8sZRP2vrbWW2X4oPqDcw6wV2DpgWmltScu6')

build_web_page(data)

print photos_count(data)

