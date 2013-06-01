module HansardParser
  require 'timeliness'
  require 'nokogiri'

  def parse filename
    f = File.open(filename)
    doc = Nokogiri::XML(f)
    f.close

    date = Timeliness.parse(filename[/([\d-]*)\.xml/, 1])
    debates = []
    debate = { :speeches => [] }

    doc.root.children.each do |n|

      if n.name == 'major-heading'
        unless debate[:speeches].empty?
          debates << debate
          debate = { :date => date, :speeches => [] }
        end
      elsif n.name == 'speech' && n.attribute('nospeaker').nil?
        speaker_id = n.attribute('speakerid').value.split("/").last
        debate[:speeches] << { :speaker_name => n.attribute('speakername').value, :speaker_id => speaker_id, :body => n.text.strip }
      end
    end
    debates
  end
end