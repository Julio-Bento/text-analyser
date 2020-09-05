# Ruby TEXT ANALYZER
# Author : https://github.com/davidBentoPereira
# Resources used :
# - https://gist.github.com/hjc/4450428
#
# https://gist.github.com/hjc/4450428

require 'prettyprint'

class Stats
  attr_accessor :text, :tokens, :characters, :words, :short_words, :short_words_percentage, :average_characters_per_word, :sentences, :average_words_per_sentence, :paragraphs

  @@stopwords = File.readlines(ARGV[1]).join

  def initialize(text)
    @text = text
    @tokens = tokenise
    @characters = count_chars
    @words = count_words
    @short_words = count_short_words
    @short_words_percentage = count_short_words_percentage
    @average_characters_per_word = count_average_characters_per_word
    @sentences = count_sentences
    @average_words_per_sentence = count_average_words_per_sentence
    @paragraphs = count_paragraphs
  end

  # Transform the text into an array of string corresponding to words
  def tokenise
    text = get_text_no_html # Strip HTML tags
    text.downcase!
    text = text.split
    text.map! {|word| word.gsub(/[.,\/#!$%\^&\*;:{}=_`~()?!]/, '')} # Strip special chars
    @tokens = text.reject {|word| word.empty?} # Strip empty strings from array

    pp @tokens

    # @tokens = text.gsub(/[.,\/#!$%\^&\*;:{}=_`~()?!]/, ' ').split
  end

  def get_text_no_html
    # Strip HTML Tags
    text_no_html = @text.gsub(/<\/?[^>]*>/, " ")

    # Strip HTML encoded whitespaces
    text_no_html.gsub(/&nbsp/, " ")
  end

  # Count all the characters in a text
  def count_chars
    # @text.length
    token_size = 0
    @tokens.map {|token| token_size += token.size}
    token_size
  end

  # Count characters in a string but without counting whitespaces
  def count_chars_no_ws
    @text.gsub(/\s+/, '').length
  end

  def count_words
    @tokens.size
  end

  # Count short-words (less than 5 characters)
  def count_short_words
    short_words = 0

    @tokens.each do |word|
      short_words += 1 if word.size < 5
    end

    short_words
  end

  def count_short_words_percentage
    (@short_words.to_f / @words * 100).round(2)
  end

  def count_average_characters_per_word
    (count_chars.to_f / @words).round(2)
  end

  def count_sentences
    get_text_no_html.split(/\.|\?|!/)
    get_text_no_html.split(/\.|\?|!/).length
  end

  def count_average_words_per_sentence
    @words.to_f / @sentences.ceil
  end

  def count_paragraphs
    # @text.split(/\n/).size + @text.split(/\n\n/).size
    @text.scan(/<p>/).size
  end

  def count_words_frequency
    tokens = @tokens
    tokens = tokens.select { |w| !@@stopwords.include?(w)}

    token_frequency = tokens.each_with_object(Hash.new(0)) { |token, hash| hash[token] += 1 }.sort_by {|word, occurence| occurence}.reverse
  end

  def count_words_density
    word_frequency = count_words_frequency

    word_density = word_frequency.each_with_object({}) { |(token, freq), hash|
      hash[token] = (freq / count_words.to_f)
    }.sort_by {|word, occurence| occurence}.reverse
  end


  def count_occurences(numb_of_occurences: 10)
    word_frequency = count_words_density

    i = 1
    word_frequency.each do |token, frequency|
      break if i > numb_of_occurences

      puts "#{token} - #{frequency} occurences"

      i += 1
    end

  end

end

=begin
TODO :
- Il faut parvenir à détecter les utls comme étant un seul et unique mot !

- Créer des classes Legibility et Visibility

=end


# Run the program

text = File.readlines(ARGV[0]).join

stats = Stats.new(text)

puts "#{stats.characters} caractères"
# puts "#{stats.count_chars_no_ws} caractères (sans espaces)"
puts "#{stats.words} Mots"
puts "#{stats.short_words} #{stats.short_words_percentage.round(0)}% Mots courts (< 5 caractères)"
puts "#{stats.average_characters_per_word} Caractères/mot"
puts "#{stats.sentences} Phrases"
puts "#{stats.average_words_per_sentence.round(0)} Mots/phrase"
puts "#{stats.paragraphs} Paragraphes"

puts ""
puts "Nombre d'occurences :"

i = 1
stats.count_words_density.each do |word|
  break if i > 10
  puts "#{word[0]} - #{(word[1] * stats.words).to_int} occurences - #{(word[1] * 100).round(0)} %"
  i += 1
end

# stats.count_words_frequency.each do |word|
#   break if i > 15
#   puts "#{word[0]} - #{word[1]}"
#   i += 1
# end


# pp stats.tokens

# p stats.get_text_no_html
