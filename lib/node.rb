class Node

attr_accessor :linked,
              :is_word,
              :value,
              :weight

def initialize
  @linked = {}
  @is_word = false
  @value = ""
  @weight = Hash.new(0)
end


end
