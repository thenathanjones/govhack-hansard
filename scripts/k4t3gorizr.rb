#encoding: utf-8
require 'httpclient'
require 'json'

# I am using Ruby 1.9.3-p392
# 'rvm use 1.9.3-p392'

API_KEY = "9b4in3bm"

def kategorise text
  c = HTTPClient.new
  beautiful_http_reponse = c.post "http://api.semantichacker.com/#{API_KEY}/category", {
      :content => text,
      :showLabels => true,
      :useShortLabels => false,
      :nCategories => 5,
      :format => 'json'
  }
  response = JSON.parse(beautiful_http_reponse.body)
  response["categorizer"]["categorizerResponse"]["categories"]
end

def konseptise text
  c = HTTPClient.new
  beautiful_http_reponse = c.post "http://api.semantichacker.com/#{API_KEY}/concept", {
      :content => text,
      :format => 'json'
  }
  response = JSON.parse(beautiful_http_reponse.body)
  response["conceptExtractor"]["conceptExtractorResponse"]["concepts"]
end
