class CreateCrawlingNavers < ActiveRecord::Migration
  def change
    create_table :crawling_navers do |t|
      t.datetime :start_time
      t.datetime :crawling_time
      t.string :keyword
      t.integer :_powerlink_jobplanet, :default => 0
      t.integer :_powerlink_jobkorea, :default => 0
      t.integer :_powerlink_saramin, :default => 0
      t.integer :_powerlink_incruit, :default => 0
      t.integer :_bizsite_jobplanet, :default => 0
      t.integer :_bizsite_jobkorea, :default => 0
      t.integer :_bizsite_saramin, :default => 0
      t.integer :_bizsite_incruit, :default => 0

      t.timestamps null: false
    end
  end
end
