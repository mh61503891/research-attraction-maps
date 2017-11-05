class InitSchema < ActiveRecord::Migration[5.1]
  def change
    create_table :attractions do |t|
      t.text :data, null:false
      t.timestamps
    end
  end
end
