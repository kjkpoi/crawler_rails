class Sleeper
	@queue = :sleep

	def self.perform(data)
		puts data["keyword_list"]
	end
end
