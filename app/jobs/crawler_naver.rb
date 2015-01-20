class CrawlerNaver
	@queue = :crawler_naver

	def self.perform(data)
		puts data.inspect
		puts data.class
		company_list = Array.new
		data.each do |key, value|
			if key.start_with?('_') && value == 'true'
				company_list.push(key[1..-1])
			end
		end
		puts company_list
		crawler_runner_naver = CrawlerRunnerNaver.new(data['keyword_list'].split,
				                                             data['deny_list'].split,
					                                           company_list,
		                                                 './app/background_crawler/database_login_info.txt')
		crawler_runner_naver.run
	end
end
