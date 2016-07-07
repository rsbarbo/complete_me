class Node

attr_accessor :linked,
              :is_word,
              :value,
              :selected_word

def initialize
  @linked = {}
  @is_word = false
  @value = ""
  @selected_word = Hash.new(0)
end


end
