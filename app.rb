require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
   
    word = params[:word] || HangpersonGame.get_random_word


    @game = HangpersonGame.new(word)
    redirect '/show'
  end

  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      result = @game.guess(letter)
    rescue
      flash[:message] = 'Invalid guess.'
    end

    flash[:message] = 'You have already used that letter.' unless result
    redirect '/show'
  end


  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    if @game.check_win_or_lose == :win
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      redirect '/lose'
    else
      erb :show
    end 
  end

  get '/win' do
    if @game.check_win_or_lose == :win
      erb :win
    else
      redirect '/show'
    end
  end

  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      redirect '/show'
    end
  end

end
