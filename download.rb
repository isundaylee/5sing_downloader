# Usage: download fc id

require 'base64'
require 'json'
require 'fileutils'
require 'open-uri'

OUTPUT_PATH = 'output'

SONG_URL = "http://5sing.kugou.com/%s/%d.html"
SONG_DETAILS_URL = "http://service.5sing.kugou.com/song/songDetailInit?SongID=%d&SongType=%s"

TICKET_REGEX = /"ticket": "([^"]*)"/

type, id = ARGV

url = SONG_URL % [type, id]
page = open(url).read

ticket = TICKET_REGEX.match(page)

unless ticket
  puts 'Invalid page. '
  exit
end

ticket = Base64.decode64(ticket[1])
file = JSON.parse(ticket)['file']
name = JSON.parse(ticket)['songName']

FileUtils.mkdir_p(OUTPUT_PATH)

output_name = File.join(OUTPUT_PATH, "#{name}.mp3")
command = "curl \"#{file}\" > \"#{output_name}\""

system(command)
