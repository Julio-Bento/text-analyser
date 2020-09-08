class StopWords
  attr_accessor :stop_words, :locale

  $available_locales = {
      "ar" => "arabic",
      "hy" => "armenian",
      "ca" => "catalan",
      "hr" => "croatian",
      "cs" => "czech",
      "da" => "danish",
      "nl" => "dutch",
      "en" => "english",
      "fa" => "farsi",
      "fi" => "finnish",
      "fr" => "french",
      "de" => "german",
      "el" => "greek",
      "he" => "hebrew",
      "hi" => "hindi",
      "hu" => "hungarian",
      "it" => "italian",
      "az" => "latin",
      "nb" => "norwegian",
      "pl" => "polish",
      "pt" => "portuguese",
      "ro" => "romanian",
      "ru" => "russian",
      "sk" => "slovak",
      "sl" => "slovenian",
      "es" => "spanish",
  }

  def initialize(locale)
    if is_available?(locale)
      @locale = locale
      @stop_words = get_stop_words
    else
      puts "The given parameter \"locale\" isn't available"
    end
  end

  private

  def is_available?(locale)
    $available_locales.include?(locale)
  end

  def get_stop_words
    @stop_words = File.readlines("./stopwords/#{$available_locales[@locale]}").join
  end
end
