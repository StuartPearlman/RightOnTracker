class CreateTrains < ActiveRecord::Migration
  def change
  	create_table :trains do |t|
  		t.string :time
  		t.string :line
  		t.string :stop
  		t.integer :user_id
  		t.string :days
  		t.timestamps
  	end
  end
end
