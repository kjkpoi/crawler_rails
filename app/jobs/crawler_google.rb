class CrawlerGoogle
	@queue = :crawler_google
	@crawler_runer_google = nil

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
		@crawler_runner_google = CrawlerRunnerGoogle.new(data['keyword_list'].gsub(' ', '').split,
				                                             data['deny_list'].gsub(' ', '').split,
					                                           company_list,
		                                                 './app/background_crawler/database_login_info.txt')

		@crawler_runner_google.run
		puts 'crawler_google'
	end

	def self.stop
		puts 'stop'
		@crawler_runner_google.stop unless @crawler_runergoogle == nil
	end
end
