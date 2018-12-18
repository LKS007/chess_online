class RookPiece < BasicPiece
  def get_available_move(cell_col_helper, pieces_col_helper)
    # cell_col_helper[1][0] = nil
    
    available_steps = {can_move: [], can_eat: []}
    available_steps = get_main_directions(
      cell_col_helper,
      pieces_col_helper,
      available_steps,
      :perpendicular
    )

  end
end
