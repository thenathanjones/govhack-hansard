require 'neography'
require 'pry'
require './naughty_things_parser'

include NaughtyThingsParser

@neo = Neography::Rest.new
@neo.set_relationship_auto_index_status(true) 

def parse_interjection int
  timestamp = int[:date].to_time.to_i
  interjection_node = @neo.create_node(:date => timestamp)

  member_node = @neo.find_node_index(:representatives, :person_id, int[:interjector_id])

  if member_node
    @neo.create_relationship(:interjected, member_node, interjection_node)
  else
    puts "No member found for person ID #{int[:interjector_id]}"
  end
end

def parse_warning warning
  timestamp = warning[:date].to_time.to_i
  warning_node = @neo.create_node(:date => timestamp)

  if warning[:warned_member_for]
    member_node = @neo.find_node_index(:representatives, :electorate, warning[:warned_member_for])
  else
    puts "Warning with no member"
  end

  if member_node
    @neo.create_relationship(:was_warned, member_node, warning_node)
  else
    puts "No member found for #{warning[:warned_member_for]}"
  end
end

def parse_removal removal
  timestamp = removal[:date].to_time.to_i
  removal_node = @neo.create_node(:date => timestamp)

  if removal[:removed_member_for]
    member_node = @neo.find_node_index(:representatives, :electorate, removal[:removed_member_for])
  else
    puts "Removal with no member"
  end

  if member_node
    @neo.create_relationship(:was_removed, member_node, removal_node)
  else
    puts "No member found for #{removal[:removed_member_for]}"
  end
end

Dir.glob('../xml/*.xml') do |hansard_file|
  puts "Parsing #{hansard_file}"
  naughty_things = parse hansard_file
  naughty_things[:interjections].each { |i| parse_interjection i }
  naughty_things[:warnings].each { |w| parse_warning w }
  naughty_things[:removals].each { |r| parse_removal r }
end