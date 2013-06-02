require 'rubygems'
require 'sinatra'
require 'json' 
require 'neography'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

get '/api/representatives' do
  @neo = Neography::Rest.new

  representatives = @neo.execute_query("START reps=node:representatives('*:*') RETURN reps")['data'].map { |r| r.last['data'] }
  representatives.to_json
end