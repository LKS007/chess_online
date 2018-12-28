class GameController < ApplicationController

  before_action :require_user
  load Rails.root.join('lib/chess_game','chess.rb')

  def start_game
    
    # Remove this!!! STRONG
    Game.delete_all
    GameStepsLog.delete_all
    # END REMOVING

    game = Chess.new
    game.start_new_game
    session[:game_id] = game.game_id
    @current_step = game.whos_move
    @game_id = game.game_id
    @available_steps = game.available_steps
    @pieces_collection = game.pieces_collection
    @player_color = game.player_color
    @whos_move = game.whos_move
  end

  def continue_game
    p "we want continue game"
  end

  def make_step

    game = Chess.new
    response = game.get_current_game_state(params[:game_id])
    game.make_step(params)

    # here you need get available steps!!!


    render json: {
      available_steps: game.available_steps,
      current_step: game.whos_move,
      pieces_collection: game.pieces_collection
    }

  end

  def end_game
  end

  def require_user 
    redirect_to new_user_session_path, alert: "For game you need to login!" unless user_signed_in?

  end
end
