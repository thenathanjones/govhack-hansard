# from ruby stats
class Array
  def histogram ; self.sort.inject({}){|a,x|a[x]=a[x].to_i+1;a} ; end
end
 
# Usage:
#   Tagcloud.tagcloudize [ "rails", "ruby", "rails" ...] do |count,max|
#      90 + 110 * ( count / max.to_f)
#   end
#  means: calculate tagcloud. Minsize 90, maxsize 90+110=200
#
#
# Expects [ "rails", "ruby", "rails" ...]
class Tagcloud
 
  # Expects [ "rails", "ruby", "rails" ...]
  def self.tagcloudize(array)
    return [] if array.empty?
    distribution = array.histogram
    max = distribution.max_by{|a,b|b}[1]
    distribution.map do |text,count|
      if block_given?
        size = yield(count,max)
      else
        size = Tagcloud.default_formula(count,max)
      end
      {:text => text, :count => count, :size => size.to_i}
    end
  end
 
  def self.default_formula(count,max)
    90 + 110 * ( count / max.to_f)
  end
end