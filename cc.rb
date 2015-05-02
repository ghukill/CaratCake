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
  subdb = params['sdb']

  # write crumb
  store[key] = value

  # return status
  "crumb stored"

end

# get crumb
get '/get' do
  
  # get params
  key = params['k']
  subdb = params['sdb']

  # write crumb
  value = store[key]

  # return status
  value

end
