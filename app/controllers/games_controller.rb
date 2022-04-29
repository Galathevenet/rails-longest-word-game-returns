class GamesController < ApplicationController
  require "json"
  require "open-uri"

  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @exists = english_word?(@word)
    @included = included?(@word.split, @letters)

    if @included == true
      if @exists == true
        @result = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @result = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
      end
    else
      @result = "sorry, but #{@word.upcase} can't be built out of #{@letters.join(", ")}"
    end
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    url_serialized = URI.open(url).read
    result = JSON.parse(url_serialized)
    result["found"]
  end

  def included?(word, letters)
    (word.uniq - letters.uniq).empty?
  end

end
