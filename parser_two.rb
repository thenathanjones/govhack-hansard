require 'timeliness'
require 'nokogiri'
require 'pp'
filename = '../openaustralia/2012-09-18.xml'

f = File.open(filename)
doc = Nokogiri::XML(f)
f.close

date = Timeliness.parse(filename[/([\d-]*)\.xml/, 1])

debates = []
debate = { :speeches => [] }
doc.root.children.each do |n|
  if n.name == 'major-heading'
    debates << debate
    debate = { :date => date, :speeches => [] }
  elsif n.name == 'speech' && n.attribute('nospeaker') != 'true'
    debate[:speeches] << { :speaker_name => n.attribute('speakername').value, :speaker_id => n.attribute('speakerid').value, :body => n.text.strip }
  end


end
pp debates