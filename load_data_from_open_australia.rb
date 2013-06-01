require 'timeliness'
require 'openaustralia'
require 'neography'
require 'pp'

key = 'CPkTYTBD4HbDBC7Y6GHDHU9H'

api = OpenAustralia::Api.new key

@neo = Neography::Rest.new
@neo.set_node_auto_index_status(true)
@neo.set_relationship_auto_index_status(true) 

@neo.create_node_auto_index
@neo.add_node_auto_index_property(:person_id)
@neo.add_node_auto_index_property(:full_name)
@neo.add_node_auto_index_property(:entry_date)

results = api.get_representatives.last(10).each do |rep|
  rep_node = @neo.create_node(:person_id => rep.person_id, :full_name => rep.full_name, :party => rep.party, :image_url => rep.image_url)

  debate_entries = api.get_debates(:person => rep.person_id, :page => 1, :type => 'representatives').results
  debate_entries.each do |entry|
    debate_node = @neo.create_node(:body => entry.body, :entry_date => Timeliness.parse(entry.hdate).to_time.to_i)
    @neo.create_relationship(:said_by, debate_node, rep_node)
  end
end