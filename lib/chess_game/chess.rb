# require_relative './modules/chess_game_helper'
load ::File.expand_path('../modules/chess_game_helper.rb', __FILE__)
load ::File.expand_path('../modules/basic_piece.rb', __FILE__)
Dir[__dir__ + "/figures/*.rb"].each {|file| load file }
class Chess
  include ChessGameHelper
  attr_reader :cell_сollections, :pieces_сollection, :figures_id, :whos_move
  
  def start_new_game
    initialize_new_game
    get_available_steps
  end

  private

  def initialize_new_game
    @figures_id = 1
    @whos_move = :white

    @cell_collections, @pieces_сollection = generate_start_position(@figures_id)

    # p @cell_collections
    # p @pieces_сollection
    
  end

  def get_available_steps
    generate_available_steps_for_every_piece(@cell_collections, @pieces_сollection, @whos_move)
    # a = PawnPiece.new
    # a.get_available_move
  end
end
