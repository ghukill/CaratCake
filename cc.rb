# CaratCake, cc.rb

# load gems
require 'sinatra'
require 'moneta'

# load config
require_relative 'config'


#-------------------- LMDB Initilization --------------------#
# Init lmdb store
store = Moneta.new(:LMDB, dir: @db_dir)


#-------------------- Routes --------------------#

# write crumb
get '/write' do
  
  # get params
  key = params['k']
  value = params['v']

  # write crumb
  
  if !key_res = store.key?(key)
  	store[key] = value
  	status = 'crumb stored'
  else
  	status = 'crumb exists, consider /update'
  end

  # return status
  status

end


# get crumb
get '/get' do
  
  # get params
  key = params['k']

  # write crumb
  value = store.load(key)

  # return status
  value

end


# update crumb
get '/update' do
  
  # get params
  key = params['k']
  value = params['v']
  
  # update
  if key_res = store.key?(key)
        store[key] = value
        status = 'crumb updated'
  else
        status = 'crumb does not exist, consider /write'
  end

  # return status
  status

end


# delete crumb
get '/delete' do
  
  # get params
  key = params['k']

  # write crumb
  store.delete(key)

  # return status
  "crumb deleted"

end
