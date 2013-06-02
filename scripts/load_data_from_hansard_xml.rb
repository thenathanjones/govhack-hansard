require 'neography'
require 'pry'
require './hansard_parser'

include HansardParser

@neo = Neography::Rest.new
@neo.set_relationship_auto_index_status(true) 

@neo.create_node_index :debates
@neo.create_node_index :speeches

def parse_debate debate
  # timestamp = Timeliness.parse(debate[:date]).to_time.to_i
  timestamp = 1234

  debate_node = @neo.create_node(:debate_id => debate[:debate_id], :title => debate[:title], :date => timestamp)
  @neo.add_node_to_index :debates, :debate_id, debate[:debate_id], debate_node
  @neo.add_node_to_index :debates, :is_processed, false, debate_node

  debate[:speeches].each do |speech|
    member_node = @neo.find_node_index(:representatives, :member_id, speech[:speaker_id])
    
    if member_node
      speech_node = @neo.create_node(:speech_id => speech[:speech_id], :body => speech[:body])

      @neo.add_node_to_index :speeches, :speech_id, speech[:speech_id], speech_node
      
      @neo.create_relationship(:delivered_by, speech_node, member_node)
      @neo.create_relationship(:part_of, speech_node, debate_node)
    else
      puts "No member with id of #{speech[:speaker_id]}"
    end
  end
end

Dir.glob('./data/*.xml') do |hansard_file|
  debates = parse hansard_file
  debates.each { |d| parse_debate d }
end