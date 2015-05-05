# CaratCake, cc.rb

# load gems
require 'sinatra'
require 'moneta'
require 'json'
require 'erb'
require 'open-uri'
require 'digest'

# load config
require_relative 'config'


#-------------------- LMDB Initilization --------------------#
# Init lmdb store
store = Moneta.new(:LMDB, dir: @db_dir, mapsize: @mapsize)


#-------------------- Helpers --------------------#

# return json
def return_json(hash)
  hash.to_json
end

# return value with custom mime headers
def return_custom_mime(mime,value)
  headers \
   "Content-Type" => mime 
  value
end

# handle get OR post requests
def get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

# use URL to retrieve and store value
def storeValueByURL(key, value, store)
  
  # retrieve URL, save to temp file
  md5 = Digest::MD5.new
  md5.update value
  temp_filename = md5.hexdigest

  File.open("/tmp/#{temp_filename}", "wb") do |saved_file|
    # the following "open" is provided by open-uri
    open(value, "rb") do |read_file|
      saved_file.write(read_file.read)
    end
  end

  # store in LMDB
  store[key] = File.open("/tmp/#{temp_filename}", 'rb') {|file| file.read }

  # delete temp file
  File.delete("/tmp/#{temp_filename}")

end



#-------------------- Core Routes --------------------#

# write crumb
get_or_post '/write' do
  
  # get params
  key = params['key']
  value = params['value']
  value_url = params['value_url']

  # write crumb
  if !key_res = store.key?(key)
  	
    # if value_url == true, download URL and set as value
    if value_url == "true"
      puts "Firing by URL..."
      storeValueByURL(key, value, store)
    else
      store[key] = value
    end
  	msg = 'crumb stored'
  
  else
  	
    msg = 'crumb exists, consider /update'
  
  end

  # return
  return_json({:msg => msg})
  

end


# get crumb
get_or_post '/get' do
  
  # get params
  key = params['key']

  # write crumb
  value = store.load(key)

  if params.has_key?('mime')
    puts "going the mime route"
    mime = params['mime']
    # return with mime
    return_custom_mime(mime, value)

  else
    puts "going the normy route"
    # return, no mime
    return_json({:value => value})

  end

end


# get crumb
get_or_post '/update' do
  
  # get params
  key = params['key']
  value = params['value']
  value_url = params['value_url']

  # update crumb
  if key_res = store.key?(key)
    
    # if value_url == true, download URL and set as value
    if value_url == "true"
      puts "Firing by URL..."
      storeValueByURL(key, value, store)
    else
      store[key] = value
    end
    msg = 'crumb updated'

  else
    msg = 'crumb does not exist, consider /write'
  end

  # return
  return_json({:msg => msg})

end


# delete crumb
get_or_post '/delete' do
  
  # get params
  key = params['key']

  # write crumb
  store.delete(key)

  # return
  return_json({:msg => "crumb deleted"})

end


#-------------------- GUI Routes --------------------#

# test forms
get_or_post '/apitest' do
  
  erb :api_test

end





#-------------------- Catch-All --------------------#

# catch-all route
get_or_post '/*' do
  
  return_json({:msg => 'Welcome to CaratCake.  Try /write, /get, /update, /delete.'})

end