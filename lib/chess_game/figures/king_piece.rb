class KingPiece < BasicPiece
  def get_available_move(cell_col_helper, pieces_col_helper)
    available_steps = {can_move: [], can_eat: []}
    
    available_steps = get_main_directions(
      cell_col_helper,
      pieces_col_helper,
      available_steps,
      :perpendicular
    )

    available_steps = get_main_directions(
      cell_col_helper,
      pieces_col_helper,
      available_steps,
      :diagonal
    )
  end
end
