module NaughtyThingsParser
  require 'nokogiri'
  require 'timeliness'

  def parse filename
    f = File.open(filename)
    doc = Nokogiri::XML(f)
    f.close

    date = Timeliness.parse(doc.xpath('.//date').text)

    naughty_things = { :interjections => [], :removals => [], :warnings => [] }

    interjection_nodes = doc.xpath('.//interjection')
    interjection_nodes.each do |i|
      interjector_id = i.xpath('./talk.start/talker/name.id').text
      naughty_things[:interjections] << { :date => date, :interjector_id => interjector_id }
    end

    removal_nodes = doc.xpath('.//*[contains(text(), "will remove") and contains(text(), "under standing order 94")]')
    removal_nodes.each do |r|
      member_for = r.text[/member for (.*) will remove /, 1]
      naughty_things[:removals] << { :date => date, :removed_member_for => member_for }
    end

    warning_nodes = doc.xpath('.//*[contains(text(), "I name the member for ")]')
    warning_nodes.each do |w|
      member_for = w.text[/I name the member for (\w*)/, 1]
      naughty_things[:warnings] << { :date => date, :warned_member_for => member_for }
    end

    naughty_things
  end
end