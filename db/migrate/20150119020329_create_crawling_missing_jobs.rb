class CreateCrawlingMissingJobs < ActiveRecord::Migration
  def change
    create_table :crawling_missing_jobs do |t|
      t.datetime :start_time
      t.string :keyword
      t.integer :is_done, :default => 0

      t.timestamps null: false
    end
  end
end
