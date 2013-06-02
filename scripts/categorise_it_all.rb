#encoding: utf-8
require 'neography'
require './scripts/k4t3gorizr'
require 'pry'

@neo = Neography::Rest.new
@neo.set_relationship_auto_index_status(true)

@neo.create_node_index :categories
@neo.create_node_index :concepts

def merge_speech_bodies(speech_rels)
  debate_text_body = ""
  speech_rels.each do |speech_rel|
    speech = @neo.get_node(speech_rel['start'])
    debate_text_body += speech['data']['body']
  end
  debate_text_body
end

def find_or_create_category_node(category)
  category_node = @neo.find_node_index(:categories, :id, category['id'])
  if category_node.nil?
    category_node = @neo.create_node(:id => category['id'], :label => category['label'])
    @neo.add_node_to_index :debates, :id, category['id'], category_node
  end
  category_node
end

def add_categories debate, categories
  categories.each do |category|
    category_node = find_or_create_category_node(category)
    rel = @neo.create_relationship(:belongs_to, debate, category_node)
    @neo.set_relationship_properties(rel, {:weight => category['weight']})
  end
  @neo.remove_node_from_index :debates, :is_categorised, debate
end

unprocessed_nodes = @neo.find_node_index(:debates, :is_categorised, 'false')

unprocessed_nodes.each do |debate|
  puts "Processing [#{debate['data']['debate_id']}] — #{debate['data']['title']}"

  speech_rels = @neo.get_node_relationships(debate, "in", "part_of")

  if speech_rels
    debate_text_body = merge_speech_bodies(speech_rels)
    puts "  #{speech_rels.size} speeches merged. Categorising ... "

    categories = kategorise(debate_text_body)
    add_categories(debate, categories)
    c = categories.map { |c| c['label']}
    puts "  #{c.size} categor#{c.size==1?'y':'ies'}: #{c.join(', ')}"
    #add_concepts(debate, konseptise(debate_text_body))
  end
end