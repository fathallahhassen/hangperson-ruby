class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses, :valid

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri, {}).body
  end

  def guess letter
    if letter =~ /[[:alpha:]]/
      letter.downcase!
      if @word.include? letter and !@guesses.include? letter
        @guesses.concat letter
        return true
      elsif !@wrong_guesses.include? letter and !@word.include? letter
        @wrong_guesses.concat letter
        return true
      else return false end
    else
      letter = :invalid
      raise ArgumentError
    end
  end

  def guess_several_letters(letters)
    letters.each { |letter| guess(letter) }
  end

  def check_win_or_lose
    return :lose if number_of_wrong_guesses >= 7
    return :win unless word_with_guesses.include?('-')
    :play
  end

  def word_with_guesses
    result = ''
    word.split('').each do |letter|
      if guesses.include?(letter)
        result << letter
      else
        result << '-'
      end
    end

    result
  end

  def already_guessed?(letter)
    (guesses+wrong_guesses).include?(letter)
  end

  def check_guess(letter)
    if letter.nil? or letter.empty?
      raise_error(ArgumentError)
    end
    if word.include?(letter)
      guesses << letter
    else
      wrong_guesses << letter
    end

  end

  def number_of_wrong_guesses
    wrong_guesses.length
  end
end