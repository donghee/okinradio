require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'data_mapper'
require 'haml'
require 'coffee_script'

# Strip the last / from the path
#before do 
#  request.env['PATH_INFO'].gsub!(/\/$/, '')
#end

SINATRA_ROOT = File.expand_path(File.dirname(__FILE__))
ARCHIVE_ROOT = File.expand_path(File.join(SINATRA_ROOT, "static", "archives"))

DataMapper::setup(:default, "sqlite3://#{SINATRA_ROOT}/okinradio.db")
DataMapper::Property::String.length(255)

class Broadcasting
  include DataMapper::Resource
  property :id, Serial
  property :title, Text
  property :movie, String
  property :image, String
  property :content, Text
  property :count, Integer, :default => 0
  property :show, Boolean 
  property :created_at, DateTime
end

class Onair
  include DataMapper::Resource
  property :id, Serial
  property :live, Boolean
  property :notice, Text
end

DataMapper.finalize
Broadcasting.auto_upgrade!
Onair.auto_upgrade!

class Controller < Sinatra::Base
  set :static, true
  set :port, 1111
  set :public_folder, File.join(SINATRA_ROOT, "static")
  set :haml, :format => :html5

  get '/?' do
    redirect '/radio/index.html'
  end

  get '/index.html' do
    #File.read(File.join(SINATRA_ROOT, "static", 'index.html'))
    @onair = Onair.get(1)
    @programs = Broadcasting.all(:order => [ :id.desc ])
    @recent_program = @programs.first
    erb :index
  end

  get '/live.html' do
    erb :live
  end

  get '/livecoding.html' do
    erb :livecoding
  end

  get '/client.js' do
    content_type "text/javascript"
    coffee :client
  end

  get '/manage/delete/:id' do
    Broadcasting.get(params[:id]).destroy
    redirect '/radio/'
  end

  get '/manage/edit/:id' do
    radio = Broadcasting.get(params[:id])
    @id = radio.id
    @title = radio.title
    @content = radio.content
    # @file = radio.movie
    @image = radio.image
    haml :edit
  end

  post '/manage/edit/:id' do
    radio = Broadcasting.get(params[:id])
  # if have a file and image, change file and update db
    radio.title = params[:title]
    radio.content = params[:content]

    #filename = params['file'][:filename]
    #filename = ARCHIVE_ROOT + '/' + params['file'][:filename]
    #if filename:
    #   movie save
    #   radio.movie = filename

    radio.save
    redirect '/radio/manage'
  end

  get '/title/:id' do 
    content_type "image/jpeg"
    # http://datamapper.org/docs/find.html
    b = Broadcasting.get(params[:id])
    b.count += 1
    b.save
    filename = ARCHIVE_ROOT + '/' + b.image
    File.read(filename)
  end

  get '/manage' do
    # start live broadcasting
    # broadcasting list 
    # upload new file

    onair = Onair.get(1)
    @live = onair.live
    @notice = onair.notice
    @programs = Broadcasting.all(:order => [ :id.desc ])
    erb :manage_onair
  end

  post '/manage' do
    #onair = Onair.first_or_create({:live => true}, {:notice => 'test'})
    onair = Onair.get(1)
    if params[:live] == 'live'
      onair.live = true
    else
      onair.live = false
    end
    onair.notice = params[:notice]
    onair.save
    redirect '/radio/manage'
  end

  get '/manage/test' do
    erb :test_upload
  end

  post '/manage/test' do
    html = ''
    filename = ARCHIVE_ROOT + '/' + 'test.mp4'
    File.open(filename, "w") do |f|
      f.write(params['file'][:tempfile].read)
    end
    html += filename

    imagefile = ARCHIVE_ROOT + '/' + 'test.png'
    File.open(imagefile, "w") do |f|
      f.write(params['image'][:tempfile].read)
    end
    html += imagefile
    html += params[:title]
    html += params[:content]

    redirect '/manage/test'
  end



  get '/manage/upload' do
    haml :upload
  end

  post '/manage/upload' do
    html = ''
    filename = ARCHIVE_ROOT + '/' + params['file'][:filename]
    File.open(filename, "w") do |f|
      f.write(params['file'][:tempfile].read)
    end
    html += filename

    imagefile = ARCHIVE_ROOT + '/' + params['image'][:filename]
    File.open(imagefile, "w") do |f|
      f.write(params['image'][:tempfile].read)
    end
    html += imagefile

    b = Broadcasting.new(:title => params[:title],
                         :movie => params['file'][:filename],
                         :image => params['image'][:filename],
                         :content => params[:content]
                        )
    b.save

    html += params[:title]
    html += params[:content]

    # system('MP4Box -hint '+ filename)

    redirect '/radio'
    # return "The file was successfully uploaded!"
  end
end

get '/' do
  'Put this in your pipe & smoke it!'
end

