require 'bundler'
Bundler.require

DataMapper.setup(:default, "mysql://root@127.0.0.1/songs")

class Song
  include DataMapper::Resource
  property :track_id , String, :key => true
  property :title, Text
  property :release , Text
  property :artist_name , Text
  property :duration , Float
  property :year , Integer
end

DataMapper.finalize
DataMapper.auto_upgrade!

before do
  content_type 'application/json'
end

get '/' do
  {"params" => params}.to_json
end

get '/songs' do
  @songs = Song.all(limit: 10)

  @songs.to_json
end


get '/song' do
  options = {}
  params.each do |k,p|
    options["#{k}.like".to_sym] = "%#{p}%" if %w(title release artist_name)
    options["#{k}".to_sym] = p.to_f if %w(year duration)
  end
  options[:limit] = 10
  puts options
  @songs = Song.all(options)

  @songs.to_json
end
