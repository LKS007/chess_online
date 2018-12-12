class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :nickname
      t.string :provider
      t.string :url

      t.timestamps
    end
  end
end
