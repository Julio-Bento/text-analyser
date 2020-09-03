#
# TEXT ANALYZER
# BY: Hayden Chudy
# https://gist.github.com/hjc/4450428

# basic setup for text analysis
stopwords = %w{alors au aucuns aussi autre avant avec avoir bon car ce cela ces ceux chaque ci comme comment dans des du dedans dehors depuis devrait doit donc dos début elle elles en encore essai est et eu fait faites fois font hors ici il ils je juste la le les leur là ma  mais mes mien moins mon mot même
  ni nommés notre nous ou où par parce pas peut plupart pour pourquoi quand que quel quelle quelles quels qui sans ses seulement si sien son sont sous soyez sujet sur
  ta tandis tellement tels tes ton tous tout trop très tu voient vont votre vous vu ça étaient état étions été être}

lines = File.readlines(ARGV[0])
line_count = lines.size
text = lines.join

# count characters
total_characters = text.length

# count chars without whitespace
total_characters_no_ws = text.gsub(/\s+/, '').length

# words
word_count = text.split.size

# count sentences and words per sentences
sentence_count = text.split(/\.|\?|!/).length
words_per_sentence = (word_count.to_f / sentence_count).ceil

# count paragraphs and sentences per paragraph
para_count = text.split(/\n\n/).size
sents_per_para = (sentence_count.to_f / para_count).ceil

# find and remove stop words, store the percentage of non-stop words that are used
words = text.scan(/\w+/)
keywords = words.select { |w| !stopwords.include?(w)}
good_percent = ((keywords.length.to_f / words.length.to_f) * 100).to_i


#
# SUMMARIZER
#
# Implements summary writing code.
# grab sentences
sentences = text.gsub(/\s+/, ' ').strip.split(/\.|\?|!/)

# sort by length
sentences_sorted = sentences.sort_by { |sent| sent.length }

# get one third of all sentences, namely the ones with the middle lengths
one_third = sentences_sorted.length / 3
ideal_sentences = sentences_sorted.slice(one_third, one_third + 1)

# trim sentences to ones that have is/are because they are descriptive
ideal_sentences.select! { |s| s =~ /is|are/ }


# output document results

puts "#{total_characters} characters"
puts "#{line_count} lines"
puts "#{total_characters_no_ws} total characters, excluding whitespace"
puts "#{word_count} total words in document"
puts "#{sentence_count} sentences in document"
puts "#{para_count} paragraphs in document"
puts "#{words_per_sentence} words per sentence (average)."
puts "#{sents_per_para} sentences per paragraph (average)."
puts "#{good_percent}% of all words are interesting"

# join to make a summary
puts "Summary: #{ideal_sentences.join(". ") + "."}"
puts "-- End of analysis"