class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :target
      t.string :slug
      t.integer :clicks, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
