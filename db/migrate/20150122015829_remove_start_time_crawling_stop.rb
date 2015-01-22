class RemoveStartTimeCrawlingStop < ActiveRecord::Migration
  def change
		remove_column :crawling_stops, :start_time
  end
end
