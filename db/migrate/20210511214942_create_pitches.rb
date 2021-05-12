class CreatePitches < ActiveRecord::Migration[6.0]
  def change
    create_table :pitches do |t|
      t.string :filename
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
