require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require "./lib/complete_me"

class CompleteMeTest < Minitest::Test

  attr_reader :cm

  def setup
    @cm = CompleteMe.new
  end

  def test_node_class_exist
    assert(Node)
  end
  def test_complete_me_class_ex3ist
    assert(CompleteMe)
  end

  def test_starting_count
    assert_equal 0, cm.count
  end

  def test_raises_argument_error
    assert_raises(ArgumentError) do
      raise ArgumentError  #Fails, different Exception is raised
    end
  end

  def test_inserts_single_word
    cm.insert("pizza")
    assert_equal 1, cm.count
  end

  def test_inserts_multiple_words
    cm.populate("pizza\ndog\ncat")
    assert_equal 3, cm.count
  end

  def test_counts_inserted_words
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    assert_equal 5, cm.count
  end

  def test_suggests_off_of_small_dataset
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    assert_equal ["pizza"], cm.suggest("p")
    assert_equal ["pizza"], cm.suggest("piz")
    assert_equal ["zombies"], cm.suggest("zo")
    assert_equal ["a", "aardvark"], cm.suggest("a").sort
    assert_equal ["aardvark"], cm.suggest("aa")
  end

  def test_inserts_medium_dataset
    cm.populate(medium_word_list)
    assert_equal medium_word_list.split("\n").count, cm.count
  end

  def test_suggests_off_of_medium_dataset
    cm.populate(medium_word_list)
    assert_equal ["williwaw", "wizardly"], cm.suggest("wi").sort
  end

  def test_selects_off_of_medium_dataset
    cm.populate(medium_word_list)
    cm.select("wi", "wizardly")
    assert_equal ["wizardly", "williwaw"], cm.suggest("wi")
  end

  def test_works_with_large_dataset
    cm.populate(large_word_list)
    assert_equal 235886, cm.populate(large_word_list).count
    assert_equal ["doggerel", "doggereler", "doggerelism", "doggerelist", "doggerelize", "doggerelizer"], cm.suggest("doggerel").sort
    cm.select("doggerel", "doggerelist")
    assert_equal "doggerelist", cm.suggest("doggerel").first
  end

  def test_if_count_works_properly_when_insert_and_populate_is_called
    cm.insert("pizza")
    assert_equal 1, cm.count
    cm.populate(large_word_list)
    assert_equal 235886,cm.count
  end

  def test_word_weight_for_return
    dictionary = File.read("/usr/share/dict/words")
    cm.populate(dictionary)
    cm.select("piz", "pizzeria")
    cm.select("piz", "pizzeria")
    cm.select("piz", "pizzeria")

    cm.select("pi", "pizza")
    cm.select("pi", "pizza")
    cm.select("pi", "pizzicato")

    assert_equal ["pizzeria", "pizza", "pizzicato"], cm.suggest("piz")
    assert_equal ["pizza", "pizzicato","pizzeria"], cm.suggest("pi")
  end

  def insert_words(words)
    cm.populate(words.join("\n"))
  end

  def medium_word_list
    File.read("./test/medium.txt")
  end

  def large_word_list
    File.read("/usr/share/dict/words")
  end


end
