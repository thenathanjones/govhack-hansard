require 'openaustralia'
require 'neography'

key = 'CPkTYTBD4HbDBC7Y6GHDHU9H'
image_root = 'http://www.openaustralia.org'
api = OpenAustralia::Api.new key

@neo = Neography::Rest.new
@neo.set_relationship_auto_index_status(true) 

@neo.create_node_index :representatives

api.get_representatives.each do |rep|
  rep_node = @neo.create_node(:person_id => rep.person_id, :member_id => rep.member_id, :full_name => rep.full_name, :party => rep.party, :image_url => image_root + rep.image_url)
  @neo.add_node_to_index :representatives, :person_id, rep.person_id, rep_node
  @neo.add_node_to_index :representatives, :member_id, rep.member_id, rep_node
  @neo.add_node_to_index :representatives, :full_name, rep.full_name, rep_node
  @neo.add_node_to_index :representatives, :party, rep.party, rep_node
end