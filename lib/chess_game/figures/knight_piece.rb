class KnightPiece < BasicPiece
  def get_available_move(cell_col_helper, pieces_col_helper)
    available_steps = {can_move: [], can_eat: []}

    directions_variants = [
      [1, 2], [1, -2],
      [-1, 2], [-1, -2],
      [2, 1], [2, -1],
      [-2, 1], [-2, -1]
    ]
    
    directions_variants.each do |coord_koeficients|
      can_move = true
      new_x_coord = @x_coord
      new_y_coord = @y_coord

      while (can_move)
        new_x_coord = new_x_coord + 1 * coord_koeficients[1]
        new_y_coord = new_y_coord + 1 * coord_koeficients[0]
        
        if ((new_x_coord >= 0 && new_x_coord < 8) && (new_y_coord >= 0 && new_y_coord < 8))
          if (cell_col_helper[new_y_coord][new_x_coord].nil?)
            available_steps[:can_move].push([new_y_coord, new_x_coord])
          elsif (check_that_rivals_cell(cell_col_helper[new_y_coord][new_x_coord]))
            available_steps[:can_eat].push([new_y_coord, new_x_coord])
          end
        end
        can_move = false
      end
    end
    available_steps
  end
end
