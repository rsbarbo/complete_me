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

  def insert_word(word)
    current_node = node
    value = ""
    word.each_char do |char|
      value += char
      current_node.linked[char] = Node.new unless current_node.
      linked.has_key?(char)
      current_node = current_node.linked[char]
    end
    @counter += 1 unless current_node.is_word
    current_node.is_word = true
    current_node.value = value
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
    node.weight.each do |word, weight|
      if list.include?(word)
        list.delete(word)
      end
      list.unshift(word)
      selected_words = Hash[node.weight.sort_by { |k, v| v }.reverse].keys
      list.each_with_index do |word, idx|
        list[idx] = selected_words[idx] if selected_words[idx] != nil
        return list if selected_words.length <= 2
        return selected_words.shift && selected_words.push(list.first) if
        selected_words != nil && list.length > 10
        return selected_words if selected_words.first.
        include?(list.first) && list.length < 5
      end
    end
    list
  end

  def select(abrev_input, word)
    if node.weight[word] == 0
      node.weight[word] = 1
    elsif node.weight[word] > 0
      node.weight[word] += 1
    end
  end

end
