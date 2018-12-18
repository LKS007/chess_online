class BasicPiece

  def initialize(piece)
    @type = piece[:type]
    @id = piece[:id]
    @color = piece[:color]
    @steps_count = piece[:steps_count]
    @letters_coord = ('a'..'h').to_a
    @coordinates = piece[:coordinates]
    @coordinates[1] = @letters_coord.index(@coordinates[1])
    @x_coord = @coordinates[1]
    @y_coord = @coordinates[0]
  end

  def get_available_move
    abort("You need to redefine method get_available_move!!!")
  end

  def get_main_directions(cells, pieces, available_steps, type)
    if type == :diagonal
      directions_variants = {
        up_left: [1, -1],
        up_right: [1, 1],
        down_right: [-1, 1],
        down_left: [-1, -1]
      }
    elsif type == :perpendicular
      directions_variants = {
        up: [1, 0],
        down: [-1, 0],
        right: [0, 1],
        left: [0, -1]
      } 
    end

    directions_variants.each do |direction, coord_koeficients|
      can_move = true
      new_x_coord = @x_coord
      new_y_coord = @y_coord

      while (can_move)
        new_x_coord = new_x_coord + 1 * coord_koeficients[1]
        new_y_coord = new_y_coord + 1 * coord_koeficients[0]
        if ((new_x_coord >= 0 && new_x_coord < 8) && (new_y_coord >= 0 && new_y_coord < 8))
          if (cells[new_y_coord][new_x_coord].nil?)
            available_steps[:can_move].push([new_y_coord, new_x_coord])
          elsif (check_that_rivals_cell(cells[new_y_coord][new_x_coord]))
            available_steps[:can_eat].push([new_y_coord, new_x_coord])
            can_move = false
          else
            can_move = false
          end
        else
          can_move = false
        end

        can_move = false if @type == :king #king can make his move only for one cell

      end
    end
    available_steps
  end

  def check_that_rivals_cell(piece_id)
    return true if @color == :white.to_s && piece_id >= 17
    return true if @color == :black.to_s && piece_id <= 16
    false
  end
end
