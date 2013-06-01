require 'openaustralia'
require 'pp'

key = 'CPkTYTBD4HbDBC7Y6GHDHU9H'

api = OpenAustralia::Api.new key

results = api.get_representatives.map { |r| {person_id: r.person_id, full_name: r.full_name} }

all_the_hansards = results.map do |rep| 
  first_page = api.get_debates(person: rep[:person_id], page: 1, type: 'representatives').results
  second_page = api.get_debates(person: rep[:person_id], page: 2, type: 'representatives').results
  third_page = api.get_debates(person: rep[:person_id], page: 3, type: 'representatives').results
  combined_pages = [first_page, second_page, third_page].flatten
  mapped_entries = combined_pages.map do |hansard_entry|
    {body: hansard_entry.body}
  end

  pp mapped_entries
end

pp all_the_hansards