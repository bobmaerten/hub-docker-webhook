require 'bundler/setup'
Bundler.require(:default)
require 'sinatra'
require 'json'
require 'yaml'

require_relative 'worker'

def validate_json(json)
  JSON.parse(json)  
rescue JSON::ParserError  
  return false  
end  

get '/' do
   halt 200, 'Hello World!'
end

post '/' do
  halt 403, 'No security token.'
end
post '/:token' do
  # security check
  halt 403, 'Wrong security token.'  unless params['token'] == ENV['SECURITY_TOKEN']
  halt 412, 'Json payload parse error.' unless json_data = validate_json(request.body.read)

  UpdateContainerWorker.perform_async(json_data)

  halt 200, 'OK'
end
