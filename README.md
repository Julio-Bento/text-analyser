# Ruby Text Analyser

## About
 
 A Ruby script analysing a given text and giving statistics in return :
 
 - number of words
 - number of sentences 
 - number of characters
 - ...

## Usage

```ruby
# 
text = "Give a man a fish, he'll eat a day. But teach a man to fish and he'll eat all his life."

# Instanciate a stats object
stats = Stats.new(text)

# You can call all of these properties to get the stats
puts "#{stats.characters} caractères" # => 
puts "#{stats.count_chars_no_ws} caractères (sans espaces)" # =>
puts "#{stats.words} Mots" #=>
puts "#{stats.short_words} #{stats.short_words_percentage}% Mots courts (< 5 caractères)" # =>
puts "#{stats.averageCharactersPerWord} Caractères/mot" # =>
puts "#{stats.sentences} Phrases" # =>
puts "#{stats.averageWordsPerSentence} Mots/phrase" # =>
puts "#{stats.paragraphs} Paragraphes" # =>
```





# Sources

To create this script, I used both of these resource :

- 
- 

Thanks a lot !