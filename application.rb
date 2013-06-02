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

get '/api/representatives/:id/speeches' do
  @neo = Neography::Rest.new

  speeches = @neo.execute_query("START member=node:representatives(member_id='#{params[:id]}') MATCH (speeches)-[:delivered_by]->(member) RETURN speeches")['data'].map { |r| r.last['data'] }
  speeches.to_json
end

get '/api/representatives/:id/interjections' do
  @neo = Neography::Rest.new

  speeches = @neo.execute_query("START member=node:representatives(member_id='#{params[:id]}') MATCH (member)-[:interjected]->(interjections) RETURN interjections")['data'].map { |r| r.last['data'] }
  speeches.to_json
end

get '/api/representatives/:id/warnings' do
  @neo = Neography::Rest.new

  speeches = @neo.execute_query("START member=node:representatives(member_id='#{params[:id]}') MATCH (member)-[:was_warned]->(warnings) RETURN speeches")['data'].map { |r| r.last['data'] }
  speeches.to_json
end

get '/api/representatives/:id/removals' do
  @neo = Neography::Rest.new

  speeches = @neo.execute_query("START member=node:representatives(member_id='#{params[:id]}') MATCH (member)-[:was_removed]->(removals) RETURN speeches")['data'].map { |r| r.last['data'] }
  speeches.to_json
end