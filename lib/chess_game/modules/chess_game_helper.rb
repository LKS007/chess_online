module ChessGameHelper
  attr_accessor :helper_figures, :pieces_col_helper, :cell_col_helper, :en_passant_helper
  def generate_start_position(f_id)

    @helper_figures = f_id
    rows_count = 8
    columns_count = 8
    chess_figures = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook]
    
    pieces_collection = Hash.new
    cell_collections = Array.new
    symbol_coordinates = ('a'..'h').to_a
    
    rows_count.times do |i|
      cell_collections[i] = Array.new
      if (i < 2 || i >= (rows_count - 2))
        chess_figures.each_with_index do |figure_name, x|

          figure = {
            type: (i == 0 || i == rows_count - 1) ? figure_name : :pawn,
            # coordinates: [i, symbol_coordinates[x]],
            coordinates: [i, x],
            id: @helper_figures,
            color: (i < 2) ? 'white' : 'black',
            steps_count: 0,
            in_game: true
          }

          pieces_collection[@helper_figures] = figure
          cell_collections[i][x] = @helper_figures
          @helper_figures += 1
        end
      else
        cell_collections[i] = [nil] *  columns_count
      end
    end

    [cell_collections, pieces_collection]
  end

  def generate_available_steps_for_every_piece(c_col, p_col, whos_move, en_passant)
    @pieces_col_helper = p_col
    @cell_col_helper = c_col
    @en_passant_helper = en_passant
    available_steps_array = Hash.new
    piece_ids = (whos_move == :white) ? (1..16).to_a : (17..32).to_a
    # p @pieces_col_helper

    piece_ids.each do |x|
      if !@pieces_col_helper[x].nil?
        available_steps_array[x] = get_steps_for_current_piece(x)

        # p p_сol[x]
      end
    end
    available_steps_array
  end

  def get_steps_for_current_piece(piece_id)

    piece_obj = get_instance_for_current_piece(@pieces_col_helper[piece_id])
    piece_obj.get_available_move(@cell_col_helper, @pieces_col_helper)
  end

  def get_instance_for_current_piece(piece)
    case piece[:type]
    when :rook
      RookPiece.new(piece)
    when :knight
      KnightPiece.new(piece)
    when :bishop
      BishopPiece.new(piece)
    when :queen
      QueenPiece.new(piece)
    when :king
      KingPiece.new(piece)
    when :pawn
      piece[:en_passant] = @en_passant_helper
      PawnPiece.new(piece)
    else
      "WTF?!?!"
    end
  end

  def validates_and_make_step(cell_collections, pieces_collection, step_info)
    @pieces_col_helper = pieces_collection
    @cell_col_helper = cell_collections

    from_coordinates = step_info[:step][:from]
    to_coordinates = step_info[:step][:to]
    figure_id = cell_col_helper[from_coordinates[0].to_i][from_coordinates[1].to_i]
    cell_to_move = cell_col_helper[to_coordinates[0].to_i][to_coordinates[1].to_i]

    move_figure_to_cell(figure_id, from_coordinates, to_coordinates)

    p "Here #{step_info[:step][:action]}"

    if step_info[:step][:action] == 'eat'
      if !cell_to_move.nil?
        # eat this figure
        pieces_col_helper.delete(cell_to_move)
      elsif @en_passant_helper != 0
        en_pas_coords = pieces_col_helper[@en_passant_helper][:coordinates]
        @cell_col_helper[en_pas_coords[0].to_i][en_pas_coords[1].to_i] = nil
        pieces_col_helper.delete(@en_passant_helper)
      end
    end



    # check if step is en_passant    
    if (@pieces_col_helper[figure_id][:type] == :pawn && 
        (to_coordinates[0].to_i - from_coordinates[0].to_i).abs == 2)
      @en_passant_helper = figure_id
    else
      @en_passant_helper = 0
    end

    [@cell_col_helper, @pieces_col_helper]
  end

  def set_enpassant_value(en_passant)
    @en_passant_helper = en_passant
  end

  def get_en_passant_helper
    @en_passant_helper
  end

  def move_figure_to_cell(figure_id, from, to)
    @cell_col_helper[from[0].to_i][from[1].to_i] = nil
    @cell_col_helper[to[0].to_i][to[1].to_i] = figure_id

    @pieces_col_helper[figure_id][:coordinates] = [to[0].to_i, to[1].to_i]
    @pieces_col_helper[figure_id][:steps_count] += 1
  end

  def add_step_to_log(game_id, old_cell_collections, cell_collections, steps_count, whos_move, step_info)
    letters_alias = ('a'..'h').to_a
    number_alias = (1..8).to_a

    step_from = letters_alias[step_info["step"]["from"][1].to_i] + number_alias[step_info["step"]["from"][0].to_i].to_s
    step_to = letters_alias[step_info["step"]["to"][1].to_i] + number_alias[step_info["step"]["to"][0].to_i].to_s
    
    step_alias = {
      figure_id: step_info["figure_id"],
      type: step_info['figure'],
      from: step_from,
      to: step_to
    }

    step_coordination = {
      from: [step_info["step"]["from"][0].to_i, step_info["step"]["from"][1].to_i],
      to: [step_info["step"]["to"][0].to_i, step_info["step"]["to"][1].to_i]
    }

    # add log
    GameStepsLog.create(
      game_id: game_id,
      cell_collections_before: old_cell_collections.to_json,
      cell_collections_after: cell_collections.to_json,
      step_number: steps_count,
      who_make_step: whos_move,
      step_alias: step_alias.to_json,
      step_coordination: step_coordination.to_json
    )
  end
end
