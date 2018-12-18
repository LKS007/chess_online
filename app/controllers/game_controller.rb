class GameController < ApplicationController
  load Rails.root.join('lib/chess_game','chess.rb')
  def start_game
    if session[:game_id].nil?

      session[:game_id] = 1 + rand(1000)
    end
    game = Chess.new
    game.start_new_game
  end

  def end_game
  end
end
