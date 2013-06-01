f = File.open('../xml/04b6e1bc_House of Representatives_2011_09_15_416_Official.xml')
doc = Nokogiri::XML(f)
f.close





removals = doc.xpath('.//para[contains(text(), "will remove") and contains(text(), "under standing order 94")]')
removals.each do |r|
  removed_member_for = r.text[/member for (.*) will remove /, 1]
end



speeches = []

date = doc.xpath('.//date').text

debate_nodes = doc.xpath('./debate')
debate_nodes.each do |d|
  
  debate_type = d.xpath('./debateinfo/title').text
  
  debate_removals = []
  removals = d.xpath('.//para[contains(text(), "will remove") and contains(text(), "under standing order 94")]')
  removals.each do |r|
    debate_removals << r.text[/member for (.*) will remove /, 1]
  end

  debate_interjections = []
  interjections = s.xpath('.//interjection')
  interjections .each do
    debate_interjections << 
  end

  speech_nodes = d.xpath('.//speech')
  speech_nodes.each do |s|
    speech_name = s.xpath('./talk.start/talker/name[@role="metadata"]')
    speech_id = s.xpath('./talk.start/talker/name.id')

    text_nodes = s.xpath('./talk.text/body/p/span')
    text_nodes.each do |t|
      unless t.xpath('./a[@type="MemberInterjecting').length > 0
        
      end
end


speech_nodes = doc.search('.//speech')
speech_nodes.map do |s|
  name = s.xpath('./talk.start/talker/name[@role="metadata"]').text
  party = s.xpath('./talk.start/talker/party').text
  electorate = s.xpath('./talk.start/talker/electorate').text


  talk_nodes = s.xpath('./talk.start/para | ./para | ./talk.text/body/p/span[@class="HPS-Normal" and not(*)]')
  body = talk_nodes.inject('') { |result, t| result + t.text.strip + ' ' }

  interjection_nodes = s.xpath('./interjection')
  interjection_nodes.each do |i|
    interjection_name = 
    interjection_body = 
  end

  body = s.xpath('./talk.text/p/span[@class="HPS-Normal" and not(*)] | ./talk.text/p/span[@class="HPS-Normal" and not(*)]').inject('') { |result, t| result + t.text.strip + ' ' }

  
end