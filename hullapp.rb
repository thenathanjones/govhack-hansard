require 'sinatra'
require 'sinatra/base'
require 'json'

class HullApp < Sinatra::Base

  # Fall back to this when needed
  set :static, true 
  set :public_folder, File.dirname(__FILE__) + '/tmp'

  get '/subscribe' do

    # Last arg is sent to the browser
    params.to_json
  end
end