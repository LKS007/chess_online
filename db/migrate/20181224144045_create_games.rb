class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :player_1   # white player
      t.integer :player_2   # 0 if play on one app
      t.string :who_current_step   #black/white
      t.text :cell_collections
      t.integer :steps_count
      t.text :pieces_collection
      t.integer :en_passant, default: 0
      t.timestamps
    end
  end
end
