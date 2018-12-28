class CreateGameStepsLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :game_steps_logs do |t|
      t.integer :game_id
      t.text :cell_collections_before
      t.text :cell_collections_after
      t.integer :step_number
      t.string :who_make_step   # white/black
      t.string :step_alias
      t.string :step_coordination
      t.timestamps
    end
  end
end
