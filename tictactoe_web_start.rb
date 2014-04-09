require "sinatra"
require "sinatra/json"
require "./lib/tictactoe_web"
require "haml"

class TicTacToeApp < Sinatra::Base

  set :tw, TicTacToeWeb.new()

  get '/' do 
    settings.tw = TicTacToeWeb.new()
    haml :index
  end

  get '/ai' do
    tw = settings.tw
    space = settings.tw.play(nil)
    json valid: true, space: space, output: tw.output, game_over: tw.game_over
  end

  get '/coin_toss' do
    tw = settings.tw
    tw.coin_toss
    json output: tw.output, player: tw.players[0].marker
  end

  get '/:space' do
    space = params[:space].to_i
    tw = settings.tw
    if tw.board.possible_moves.include?(space)
      space = tw.play(space)
      json valid: true, space: space, output: tw.output, game_over: tw.game_over
    else
      json valid: false, error: "#{space} is an invalid move."
    end 
  end

end

TicTacToeApp.run!
