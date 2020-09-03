class Stats
  attr_accessor :text, :tokens, :characters, :words,  :short_words, :short_words_percentage, :averageCharactersPerWord, :sentences, :averageWordsPerSentence, :paragraphs

  @@stopwords = File.readlines(ARGV[1]).join

    def initialize(text)
      @text = text
      @tokens = tokenise
      @characters = count_chars
      @words = count_words
      @short_words = count_short_words
      @short_words_percentage = count_short_words_percentage
      @averageCharactersPerWord = count_average_characters_per_word
      @sentences = count_sentences
      @averageWordsPerSentence = count_average_words_per_sentence
      @paragraphs = count_paragraphs
    end

    def tokenise
      # Extract ponctuation signs ": , ."
      # filter_proc = filter_to_proc(/[.,\/#!$%\^&\*;:{}=\-_`~()]/)
      # @text.split.map(&:downcase).reject { |token| filter_proc.call(token) }

      @text.tr(':.,()[]', '').split.map(&:downcase)
    end

    # Count all the characters in a text
    def count_chars
      total_characters = @text.length
    end

    # Count characters in a string but without counting whitespaces
    def count_chars_no_ws
      total_characters_no_ws = @text.gsub(/\s+/, '').length
    end

    def count_words
      word_count = @tokens.size
    end

    # Count short-words (less than 5 characters)
    def count_short_words
      words = @text.split

      short_words = 0

      words.each do |word|
        short_words += 1 if word.size < 5
      end

      short_words
    end

    def count_short_words_percentage
      (@short_words.to_f / @words * 100).round(2)
    end

    def count_average_characters_per_word
      (count_chars_no_ws.to_f / @words).round(2)
    end

    def count_sentences
      @text.split(/\.|\?|!/).length
    end

    def count_average_words_per_sentence
      count_words.to_f / count_sentences.ceil
    end

    def count_paragraphs
      text.split(/\n\n/).size
    end


     # TODO : Travailler sur les 3 fonctions ci-dessous

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






    def filter_to_proc(filter)
      if filter.respond_to?(:to_a)
        filter_procs_from_array(filter)
      elsif filter.respond_to?(:to_str)
        filter_proc_from_string(filter)
      elsif regexp_filter = Regexp.try_convert(filter)
        ->(token) {
          token =~ regexp_filter
        }
      elsif filter.respond_to?(:to_proc)
        filter.to_proc
      else
        raise ArgumentError,
          "`filter` must be a `String`, `Regexp`, `lambda`, `Symbol`, or an `Array` of any combination of those types"
      end
    end

    # @api private
    def filter_procs_from_array(filter)
      filter_procs = Array(filter).map &method(:filter_to_proc)
      ->(token) {
        filter_procs.any? { |pro| pro.call(token) }
      }
    end

    # @api private
    def filter_proc_from_string(filter)
      normalized_exclusion_list = filter.split.map(&:downcase)
      ->(token) {
        normalized_exclusion_list.include?(token)
      }
    end

  end

=begin 
TODO :

- Regarder en ruby comment se fait le comptage de caractères, car mes chiffres divergent un peu

- Essayer de prendre du HTML en entrée
=> Le nombre de paragraphe ne correspond pas du tout. I faut trouver une autre méthode de calcul
=> Il faut compter le nombre de balise <p>

- Les mots avec une apostrophe comme " lorsqu'ils " sont comptés comme étant deux mots différents.
=> S'inspirer de la gem word_count pour changer de méthode de comptage de mot.

=end


# Run the program

text = File.readlines(ARGV[0]).join.gsub(/<\/?[^>]*>/, "")

stats = Stats.new(text)

puts "#{stats.characters} caractères"
puts "#{stats.count_chars_no_ws} caractères (sans espaces)"
puts "#{stats.words} Mots"
puts "#{stats.short_words} #{stats.short_words_percentage}% Mots courts (< 5 caractères)"
puts "#{stats.averageCharactersPerWord} Caractères/mot"
puts "#{stats.sentences} Phrases"
puts "#{stats.averageWordsPerSentence} Mots/phrase"
puts "#{stats.paragraphs} Paragraphes"

puts ""
puts "Nombre d'occurences :"

i = 1

# stats.count_words_density.each do |word|
#   break if i > 10

#   puts "#{word[0]} - #{(word[1] * stats.words).to_int} occurences - #{(word[1] * 100).round(0)} %"

#   i += 1
# end



stats.count_words_frequency.each do |word|
  break if i > 15

  puts "#{word[0]} - #{word[1]}"

  i += 1
end


# p stats.tokens