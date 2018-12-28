class PawnPiece < BasicPiece
  def get_available_move(cell_col_helper, pieces_col_helper)



    
    available_steps = {can_move: [], can_eat: []}
    step_koefficient = @color == :white.to_s ? 1 : -1
    max_length_step = @steps_count == 0 ? 2 : 1
    # cell_col_helper[@y_coord + 1][2] = 18
    i = 1
    can_move = true

    while (can_move)
      new_y_coord = @y_coord + i * step_koefficient
      if (new_y_coord < 8 && new_y_coord >= 0)
        # move_steps
        if (cell_col_helper[new_y_coord][@x_coord].nil?)    
          available_steps[:can_move].push([new_y_coord, @x_coord])
        else 
          can_move = false
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
      can_move = false if i == max_length_step
      i += 1
    end

    if @en_passant != 0
      en_pass_piece = pieces_col_helper[@en_passant]
      if (en_pass_piece[:coordinates][0] == @y_coord)
        if (en_pass_piece[:coordinates][1] == @x_coord - 1 || en_pass_piece[:coordinates][1] == @x_coord + 1)
          # p "Yoc can eat it!" 
          # p "You coord = #{@y_coord}: #{@x_coord}"
          new_y_coord = @y_coord + 1 * step_koefficient
          new_x_coord = en_pass_piece[:coordinates][1]
          available_steps[:can_eat].push([new_y_coord, new_x_coord])
        end
      end
    else
      # p "Nothing"
    end
    p available_steps

    available_steps
  end
end
