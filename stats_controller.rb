require_relative 'stats_worker'
require_relative 'stats'

class StatsController
  # Get html and local strings and return a Stat Object
  def get_stats(html, locale)
    worker = StatsWorker.new(html, locale)
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
  end
end

html = File.readlines("text.html").join

statscontroller = StatsController.new

statscontroller.get_stats(html, "fr")





