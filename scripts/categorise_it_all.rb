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
    @neo.add_node_to_index :categories, :id, category['id'], category_node
  end
  category_node
end

def add_categories debate, categories
  categories.each do |category|
    category_node = find_or_create_category_node(category)
    rel = @neo.create_relationship(:belongs_to_category, debate, category_node)
    @neo.set_relationship_properties(rel, {:weight => category['weight']})
  end
  @neo.remove_node_from_index :debates, :is_categorised, debate
end

def find_or_create_concept_node(concept)
  concept_node = @neo.find_node_index(:concepts, :label, concept['label'])
  if concept_node.nil?
    concept_node = @neo.create_node(:label => concept['label'])
    @neo.add_node_to_index :concepts, :label, concept['label'], concept_node
  end
  concept_node
end

def add_concepts debate, concepts
  concepts.each do |concept|
    concept_node = find_or_create_concept_node(concept)
    rel = @neo.create_relationship(:relates_to_concept, debate, concept_node)
    @neo.set_relationship_properties(rel, {:weight => concept['weight']})
  end
  @neo.remove_node_from_index :debates, :is_conceptised, debate
end

uncategorised = @neo.find_node_index(:debates, :is_categorised, 'false')
uncategorised.each do |debate|
  puts "Processing [#{debate['data']['debate_id']}] — #{debate['data']['title']}"

  speech_rels = @neo.get_node_relationships(debate, "in", "part_of")

  if speech_rels
    debate_text_body = merge_speech_bodies(speech_rels)

    puts "  #{speech_rels.size} speeches merged. Categorising ... "

    categories = kategorise(debate_text_body)
    add_categories(debate, categories)
    c = categories.map { |c| c['label'] }
    puts "  #{c.size} categor#{c.size==1 ? 'y' : 'ies'}: #{c.join(', ')}"
  end
end

unconceptised = @neo.find_node_index(:debates, :is_conceptised, 'false')
unconceptised.each do |debate|
  puts "Processing [#{debate['data']['debate_id']}] — #{debate['data']['title']}"

  speech_rels = @neo.get_node_relationships(debate, "in", "part_of")

  if speech_rels
    debate_text_body = merge_speech_bodies(speech_rels)

    puts "  #{speech_rels.size} speeches merged. Conceptising ... "

    concepts = konseptise(debate_text_body)
    add_concepts(debate, concepts)
    c = concepts.map { |c| c['label'] }
    puts "  #{c.size} concept#{c.size==1 ? '' : 's'}: #{c.join(', ')}"
  end
end
