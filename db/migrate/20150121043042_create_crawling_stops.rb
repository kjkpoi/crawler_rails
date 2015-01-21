class CreateCrawlingStops < ActiveRecord::Migration
  def change
    create_table :crawling_stops do |t|
      t.string :crawler_name
      t.integer :current_status

      t.timestamps null: false
    end
  end
end
