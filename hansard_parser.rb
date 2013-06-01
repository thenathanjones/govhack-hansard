module HansardParser
  require 'nokogiri'

  def parse filename

    f = File.open(filename)
    doc = Nokogiri::XML(f)
    f.close

    speeches = []

    date = doc.xpath('.//date').text
    speech_nodes = doc.search('.//speech')
    speech_nodes.map do |s|
      name = s.xpath('.//talker//name').text
      party = s.xpath('.//talker//party').text
      electorate = s.xpath('.//talker//electorate').text
      body = s.xpath('./talk.text//p/span[@class="HPS-Normal" and not(*)]').inject('') { |result, t| result + t.text.strip + ' ' }
      {:date => date, :name => name, :party => party, :electorate => electorate, :body => body }
    end
  end
end

