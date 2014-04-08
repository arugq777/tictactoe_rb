require "sinatra"
require "sinatra/json"
require "./lib/tictactoe_web"

class TicTacToeApp < Sinatra::Base

  set :tw, TicTacToeWeb.new()

  get '/' do 
    settings.tw = TicTacToeWeb.new()
    erb :index
  end

  get '/ai' do
    puts "/ai"
    space = settings.tw.play(nil)
    json valid: true, space: space, output: settings.tw.output, game_over: settings.tw.game_over
  end

  get '/coin_toss' do
    puts "/coin_toss"
    settings.tw.coin_toss
    json output: settings.tw.output, player: settings.tw.players[0].marker
  end

  get '/:space' do
    space = params[:space].to_i
    puts "/:space #{space}"
    if settings.tw.board.possible_moves.include?(space)
      space = settings.tw.play(space)
      json valid: true, space: space, output: settings.tw.output, game_over: settings.tw.game_over
    else
      json valid: false, error: "#{space} is an invalid move."
    end 
  end

end

TicTacToeApp.run!
