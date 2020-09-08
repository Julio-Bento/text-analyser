class Stats
  attr_accessor :legibility, :visibility

  def initialize
    @legibility = Legibility.new
    @visibility = Visibility.new
  end

  class Legibility
    attr_accessor :characters, :words, :short_words, :short_words_percentage, :average_characters_per_word,
                  :sentences, :average_words_per_sentence, :paragraphs, :average_sentences_per_paragraphs
  end

  class Visibility
    attr_accessor :word_frequencies

    def initialize
      @word_frequencies = Array
    end
  end

end

class WordFrequency
  attr_accessor :word, :occurences, :percentage
end
