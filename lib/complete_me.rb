require_relative "node"
require "pry"

class CompleteMe

  attr_accessor :node, :counter, :something

  def initialize
    @node = Node.new
    @counter = 0
  end

  def count
    @counter
  end

  def insert(word)
    raise ArgumentError,
    "Argument given is not a word" unless word.is_a?(String) && word.length > 0
    insert_word(word)
  end

  def populate(words)
    words.split("\n").each do |word|
      insert(word)
    end
  end

  def suggest(input)
    word_chars = input.chars
    search_matches(word_chars, node)
  end

  def select(abrev_input, word)
    @relevant = node.selected_word[abrev_input] = word
  end

  def insert_word(word)
    current_node = node
    value = ""
    word.each_char do |char|
      value += char
      current_node.linked[char] = Node.new unless current_node.linked.has_key?(char)
      current_node = current_node.linked[char]
    end
    @counter += 1 unless current_node.is_word
    current_node.is_word = true
    current_node.value = value
    @weight += 1 while (current_node.is_word && current_node.value == @relevant)
  end

  def search_matches(word_chars, current_node)
    list = []
    letter = word_chars.shift
    if current_node.linked.has_key?(letter)
      search_matches(word_chars, current_node.linked[letter])
    else
      list << current_node.value if current_node.is_word
      search_rest_of_trie(current_node, list)
    end
  end

  def search_rest_of_trie(node, list)
    node.linked.each_value do |node|
      list << node.value if node.is_word
      search_rest_of_trie(node, list)
    end
    check_relevance(list)
  end

  def check_relevance(list)
    node.selected_word.values.each do |word|
      if list.include?(word)
        list.delete(word)
      end
      list.unshift(word)
    end
    list
  end

end
