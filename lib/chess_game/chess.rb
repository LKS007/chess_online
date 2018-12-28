# require_relative './modules/chess_game_helper'
load ::File.expand_path('../modules/chess_game_helper.rb', __FILE__)
load ::File.expand_path('../modules/basic_piece.rb', __FILE__)
Dir[__dir__ + "/figures/*.rb"].each {|file| load file }
class Chess
  include ChessGameHelper
  attr_reader :cell_collections, :pieces_collection, :figures_id, :whos_move, :available_steps
  attr_reader :player_color, :game_id, :steps_count, :en_passant

  def start_new_game
    initialize_new_game
    get_available_steps
  end

  def get_current_game_state(game_id)
    if !Game.where(id: game_id).empty?
      game = Game.find(game_id)
      @cell_collections = JSON.parse(game[:cell_collections])
      
      p_col = JSON.parse(game[:pieces_collection])
      @pieces_collection = Hash[p_col.map{ |k, v| [k.to_i, Hash[v.map{ |k2, v2| [k2.to_sym, v2]}] ] }]
      @pieces_collection.each do |key, value| 
        @pieces_collection[key][:type] = @pieces_collection[key][:type].to_sym
      end

      @whos_move = game[:who_current_step].to_sym
      @steps_count = game[:steps_count]
      @en_passant = game[:en_passant].to_i
      @game_id = game[:id]

      # p @pieces_collection

      # abort("STOP")

      # p game[:cell_collections]
    else
      return "We can't find this game! Check this error"
    end
  end

  def make_step(step_info)
    old_cell_collections = @cell_collections
    old_pieces_collection = @pieces_collection

    # add en_passant
    set_enpassant_value(@en_passant)
    
    @cell_collections, @pieces_collection = validates_and_make_step(
      @cell_collections, @pieces_collection, step_info
    )

    @en_passant = get_en_passant_helper

    @steps_count += 1

    add_step_to_log(
      @game_id,
      old_cell_collections,
      @cell_collections,
      @steps_count,
      @whos_move,
      step_info
    )

    if @whos_move == :white
      @whos_move = :black
    else
      @whos_move = :white
    end

    Game.update(@game_id, {
      cell_collections: @cell_collections.to_json,
      steps_count: @steps_count,
      who_current_step: @whos_move,
      pieces_collection: @pieces_collection.to_json,
      en_passant: @en_passant
    })

    get_available_steps
  end

  private

  def initialize_new_game
    @figures_id = 1
    @whos_move = :white

    # CHANGE THIS SOON!!!
    @player_color = :white
    @en_passant = 0

    @cell_collections, @pieces_collection = generate_start_position(@figures_id)
    
    # @cell_collections[2][3] = 18


    game = Game.create(
      cell_collections: @cell_collections.to_json,
      steps_count: 0,
      pieces_collection: @pieces_collection.to_json,
      who_current_step: @whos_move,
      en_passant: @en_passant
    )

    @game_id = game.id

    # p @cell_collections
    # p @pieces_collection
    
  end

  def get_available_steps
    @available_steps = generate_available_steps_for_every_piece(
      @cell_collections,
      @pieces_collection,
      @whos_move,
      @en_passant
    )


    # p "HERE!!! I NEED INFO"
    # p @available_steps
  end
end
