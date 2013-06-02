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
      #:showLabels => true,
      #:useShortLabels => false,
      #:nCategories => 5,
      :format => 'json'
  }
  response = JSON.parse(beautiful_http_reponse.body)
  response["conceptExtractor"]["conceptExtractorResponse"]["concepts"]
end
#
##puts kategorise "In 2011, the Independent Review of Aid Effectiveness recommended that Australia join the group as it would represent value for money, and be a high-level indication of Australia's commitment to development in Africa. The government's 2011 response to that review, An Effective Aid Program for Australia, agreed in principle to the recommendation, subject to the outcome of a detailed assessment. That detailed assessment, along with the Australian Multilateral Assessment and Comprehensive Aid Policy Framework, from 2012, and the Joint Standing Committee on Treaties report from this year have all agreed that joining the group would have positive outcomes for Australia's aid program."
#puts "Try me out! Type or paste one line of text here to see what it is about. I am always right :("
#puts ""
#what_you_type = gets
#
#puts "────────────────────"
#puts "CATEGORIES"
#puts kategorise what_you_type
#puts ""
#puts "CONCEPTS"
#puts konseptise what_you_type
