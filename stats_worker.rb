require_relative 'stats'

class StatsWorker
  attr_accessor :html, :tokens, :stop_words, :locale

  def initialize(html, locale)
    @html = html
    @locale = locale
    @stop_words = File.readlines("./stopwords/french").join # TODO: Create a StopWords class returning the stop words of the choosen locale
    @tokens = tokenise
  end

  def compute_stats
    stats = Stats.new

    # Fill in Legibility object
    stats.legibility.characters = count_chars
    stats.legibility.words = count_words
    stats.legibility.short_words = count_short_words
    stats.legibility.short_words_percentage = count_short_words_percentage
    stats.legibility.average_characters_per_word = count_average_characters_per_word
    stats.legibility.sentences = count_sentences
    stats.legibility.average_words_per_sentence = count_average_words_per_sentence
    stats.legibility.paragraphs = count_paragraphs
    stats.legibility.average_sentences_per_paragraphs = count_avg_sentences_per_prgph

    # Fill in Visibility object
    words_freq = count_words_frequencies

    words_frequencies = stats.visibility.word_frequencies = []

    10.times do |i|
      word_frequency = WordFrequency.new

      word_frequency.word = words_freq[i][0]
      word_frequency.occurences = (words_freq[i][1] * count_words).to_int
      word_frequency.percentage = (words_freq[i][1] * 100).round(0)

      words_frequencies << word_frequency
      end

    stats
  end

  # private

  def tokenise
    text = get_text_no_html # Strip HTML tags
    text.downcase!
    text = text.split
    text.map! {|word| word.gsub(/[.,\/#!$%\^&\*;:{}=_`~()?!]/, '')} # Strip special chars
    @tokens = text.reject {|word| word.empty?} # Strip empty strings from array
  end

  def get_text_no_html
    text_no_html = @html.gsub(/<\/?[^>]*>/, " ") # Strip HTML Tags
    text_no_html.gsub(/&nbsp/, " ") # Strip HTML encoded whitespaces
  end

  def count_chars
    token_size = 0
    @tokens.map {|token| token_size += token.size}
    token_size
  end

  def count_words
    @tokens.size
  end

  def count_short_words
    short_words = 0

    @tokens.each do |word|
      short_words += 1 if word.size < 5
    end

    short_words
  end

  def count_short_words_percentage
    (count_short_words.to_f / count_words * 100).round(2)
  end

  def count_average_characters_per_word
    (count_chars.to_f / count_words).round(2)
  end

  def count_sentences
    get_text_no_html.split(/[^\.!?]+[\.!?]/).length
  end

  def count_average_words_per_sentence
    count_words.to_f / count_sentences.ceil
  end

  def count_paragraphs
    @html.scan(/<p>/).size
  end

  def count_avg_sentences_per_prgph
    (count_sentences.to_f / count_paragraphs).round(2)
  end

  def count_words_frequencies
    tokens = @tokens
    tokens = tokens.select { |w| !@stop_words.include?(w)}
    word_frequency = tokens.each_with_object(Hash.new(0)) { |token, hash| hash[token] += 1 }.sort_by {|word, occurence| occurence}.reverse
    word_frequency.each_with_object({}) { |(token, freq), hash| hash[token] = (freq / count_words.to_f) }.sort_by {|word, occurence| occurence}.reverse
  end

end

html = File.readlines("text.html").join

worker = StatsWorker.new(html, "fr")

stats = worker.compute_stats

puts "#{stats.legibility.characters} caractères"
puts "#{stats.legibility.words} Mots"
puts "#{stats.legibility.short_words} #{stats.legibility.short_words_percentage.round(0)}% Mots courts (< 5 caractères)"
puts "#{stats.legibility.average_characters_per_word} Caractères/mot"
puts "#{stats.legibility.sentences} Phrases"
puts "#{stats.legibility.average_words_per_sentence.round(0)} Mots/phrase"
puts "#{stats.legibility.paragraphs} Paragraphes"
puts "#{stats.legibility.average_sentences_per_paragraphs} Phrases/paragraphe"

stats.visibility.word_frequencies.each do |word|
  puts "#{word.word} - #{word.occurences} occurences - #{word.occurences} %"
end
