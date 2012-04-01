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

DataMapper.finalize
Broadcasting.auto_upgrade!

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
    @programs = Broadcasting.all(:order => [ :id.desc ])
    erb :index
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
    @title = radio.title
    @content = radio.content
    haml :edit
  end

  post '/manage/edit/:id' do
  # if have a file and image, change file and update db
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
  end

  get '/manage/list' do
    @programs = Broadcasting.all(:order => [ :id.desc ])
    erb :manage_list
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

    redirect '/radio'
    # return "The file was successfully uploaded!"
  end
end
