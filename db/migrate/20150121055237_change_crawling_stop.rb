class ChangeCrawlingStop < ActiveRecord::Migration
  def change
		change_column :crawling_stops, :current_status, :string
		add_column :crawling_stops, :start_time, :datetime, :null => false
  end
end
