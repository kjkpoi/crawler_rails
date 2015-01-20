class CreateCrawlingGoogles < ActiveRecord::Migration
  def change
    create_table :crawling_googles do |t|
      t.datetime :start_time
      t.datetime :crawling_time
      t.string :keyword
      t.integer :_jobplanet, :default => 0
      t.integer :_jobkorea, :default => 0
      t.integer :_saramin, :default => 0
      t.integer :_incruit, :default => 0

      t.timestamps null: false
    end
  end
end
