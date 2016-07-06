require_relative "node"
require "pry"

class CompleteMe

  attr_accessor :node, :counter

  def initialize
    @node = Node.new
    @counter = 0
  end

  def count
    counter
  end

  def insert(word)
    raise ArgumentError,
    "Argument given is not a word" unless word.is_a?(String) && word.length > 0
    insert_word(word)
  end

  def insert_word(word)
    current_node = node
    value = ""
    word.each_char do |char|
      value += char
      current_node.children[char] = Node.new unless current_node.children.has_key?(char)
      current_node = current_node.children[char]
    end
    current_node.is_word = true
    current_node.value = value
    @counter += 1
  end

  def populate(words)
    words.split("\n").each do |word|
      insert(word)
    end
  end

  def suggest(input)
    word_chars = input.chars
    list = search_matches(word_chars, node)
  end

  def search_matches(word_chars, current_node)
    list = []
    letter = word_chars.shift
    if current_node.children.has_key?(letter)
      search_matches(word_chars, current_node.children[letter])
    else
      list << current_node.value if current_node.is_word == true
      search_rest_of_trie(current_node, list)
    end
  end

  def search_rest_of_trie(node, list)
    node.children.each_value do |node|
      list << node.value if node.is_word == true
      search_rest_of_trie(node, list)
    end
    list
  end

end
