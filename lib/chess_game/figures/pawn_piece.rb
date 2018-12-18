class PawnPiece < BasicPiece
  def get_available_move(cell_col_helper, pieces_col_helper)
    
    available_steps = {can_move: [], can_eat: []}
    step_koefficient = @color == :white.to_s ? 1 : -1
    max_length_step = @steps_count == 0 ? 2 : 1
    cell_col_helper[@y_coord + 1][2] = 18
    i = 1

    while (i <= max_length_step)
      new_y_coord = @y_coord + i * step_koefficient
      if (new_y_coord < 8 && new_y_coord >= 0)
        # move_steps
        if (cell_col_helper[new_y_coord][@x_coord].nil?)    
          available_steps[:can_move].push([new_y_coord, @x_coord])
        end
        # eats steps
        if (i == 1)
          new_x_coords = [@x_coord - i, @x_coord + i]
          new_x_coords.each do |x|
            if (x >= 0 && x < 8 && !cell_col_helper[new_y_coord][x].nil?)
              if (check_that_rivals_cell(cell_col_helper[new_y_coord][x]))
                available_steps[:can_eat].push([new_y_coord, x])
              end
            end
          end
        end
      end
      i += 1
    end
    available_steps
  end
end
