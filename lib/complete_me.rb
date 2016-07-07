require_relative "node"
require "pry"

class CompleteMe

  attr_accessor :node, :counter

  def initialize
    @node = Node.new
    @counter = 0
  end

  def count(current_node=node)
    current_node.linked.each_value do |node|
      @counter += 1 if node.is_word
      count(node)
    end
    @counter
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
      current_node.linked[char] = Node.new unless current_node.linked.has_key?(char)
      current_node = current_node.linked[char]
    end
    current_node.is_word = true
    current_node.value = value
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
    node.weight.values.each do |word|
      if list.include?(word)
        list.delete(word)
      end
      list.unshift(word)
    end
    list
  end

  def select(abrev_input, word)
    node.weight[abrev_input] = word
    #if select include more than 1 word, will give the select words
    #Plus one word from the dictionary, but never return more than X amount of words
  end

end
