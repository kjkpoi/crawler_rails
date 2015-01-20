class CrawlingGoogle < ActiveRecord::Base

 def self.to_csv
    CSV.generate do |csv|
		  csv << column_names
			all.each do |product|
				product['keyword'] = product['keyword'].encode('EUC-KR', 'UTF-8')
				csv << product.attributes.values_at(*column_names)
			end
		end
	end

end
