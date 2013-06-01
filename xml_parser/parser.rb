require 'nokogiri'

filename = '../xml/9b046044_House of Representatives_2013_03_21_1832_Official.xml'

f = File.open(filename)
doc = Nokogiri::XML(f)
f.close

puts 'Date: ' + doc.xpath('.//date').text

speeches = doc.search('.//speech')

speeches.each do |s|
  puts 'Name: ' + s.xpath('.//talker//name').text
  puts 'Party: ' + s.xpath('.//talker//party').text
  puts 'Electorate: ' + s.xpath('.//talker//electorate').text
  puts 'Body: ' + s.xpath('./talk.text//p/span[@class="HPS-Normal" and not(*)]').inject('') { |result, t| result + t.text.strip + ' ' }
end
