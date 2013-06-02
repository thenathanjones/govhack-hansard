module HansardParser
  require 'timeliness'
  require 'nokogiri'

  def parse filename
    f = File.open(filename)
    doc = Nokogiri::XML(f)
    f.close

    date = Timeliness.parse(filename[/([\d-]*)\.xml/, 1], :format => 'yyyy-mm-dd')
    debates = []
    debate = { :speeches => [] }

    doc.root.children.each do |n|

      if n.name == 'minor-heading'
        unless debate[:speeches].empty?
          debates << debate
          debate_id = n.attribute('id').value.split("/").last
          debate = { :debate_id => debate_id, :title => n.text.strip, :date => date, :speeches => [] }
        end
      elsif n.name == 'speech' && n.attribute('nospeaker').nil?
        speech_id = n.attribute('id').value.split("/").last
        speaker_id = n.attribute('speakerid').value.split("/").last
        debate[:speeches] << { :speech_id => speech_id, :speaker_name => n.attribute('speakername').value, :speaker_id => speaker_id, :body => n.text.strip }
      end
    end
    debates
  end
end