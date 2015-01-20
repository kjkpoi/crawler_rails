class CreateCrawlingErrors < ActiveRecord::Migration
  def change
    create_table :crawling_errors do |t|
      t.datetime :start_time
      t.datetime :error_time
      t.string :keyword
      t.text :error_msg

      t.timestamps null: false
    end
  end
end
