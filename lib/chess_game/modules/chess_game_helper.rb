module ChessGameHelper
  attr_accessor :helper_figures, :pieces_col_helper, :cell_col_helper
  def generate_start_position(f_id)

    @helper_figures = f_id
    rows_count = 8
    columns_count = 8
    chess_figures = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook]
    
    pieces_сollection = Hash.new
    cell_collections = Array.new
    symbol_coordinates = ('a'..'h').to_a
    
    rows_count.times do |i|
      cell_collections[i] = Array.new
      if (i < 2 || i >= (rows_count - 2))
        chess_figures.each_with_index do |figure_name, x|

          figure = {
            type: (i == 0 || i == rows_count - 1) ? figure_name : :pawn,
            coordinates: [i, symbol_coordinates[x]],
            id: @helper_figures,
            color: (i < 2) ? 'white' : 'black',
            steps_count: 0,
            in_game: true
          }

          pieces_сollection[@helper_figures] = figure
          cell_collections[i][x] = @helper_figures
          @helper_figures += 1
        end
      else
        cell_collections[i] = [nil] *  columns_count
      end
    end

    [cell_collections, pieces_сollection]
  end

  def generate_available_steps_for_every_piece(c_col, p_col, whos_move)
    @pieces_col_helper = p_col
    @cell_col_helper = c_col
    available_steps_array = Hash.new
    piece_ids = (whos_move == :white) ? (1..16).to_a : (17..32).to_a

    piece_ids.each do |x|
      if !@pieces_col_helper[x].nil?
        available_steps_array[x] = get_steps_for_current_piece(x)

        # p p_сol[x]
      end
    end
    p available_steps_array
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
      PawnPiece.new(piece)
    else
      "WTF?!?!"
    end
  end

end
