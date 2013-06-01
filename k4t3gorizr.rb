# I am using Ruby 1.9.3-p392
# 'rvm use 1.9.3-p392'

def kategorise text
  [
      {"id" => "288", "weight" => "0.18081734", "label" => "Computers/Software/Human_Resources"},
      {"id" => "141", "weight" => "0.17852962", "label" => "Business/Education_and_Training"},
      {"id" => "826", "weight" => "0.17403297", "label" => "Society/Government/Multilateral"},
      {"id" => "846", "weight" => "0.16250728", "label" => "Society/Issues/Economic"},
      {"id" => "167", "weight" => "0.15244144", "label" => "Business/Healthcare"}
  ]
end

kategorise "In 2011, the Independent Review of Aid Effectiveness recommended that Australia join the group as it would represent value for money, and be a high-level indication of Australia's commitment to development in Africa. The government's 2011 response to that review, An Effective Aid Program for Australia, agreed in principle to the recommendation, subject to the outcome of a detailed assessment. That detailed assessment, along with the Australian Multilateral Assessment and Comprehensive Aid Policy Framework, from 2012, and the Joint Standing Committee on Treaties report from this year have all agreed that joining the group would have positive outcomes for Australia's aid program."
