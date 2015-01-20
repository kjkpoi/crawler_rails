require 'active_record'
require 'mysql2'

class Crawling_error < ActiveRecord::Base
end

class Crawling_missing_job < ActiveRecord::Base
end

class Crawling_google < ActiveRecord::Base
end

class Crawling_naver < ActiveRecord::Base
end

class DatabaseManager

    def initialize(db_login_info)
        ActiveRecord::Base.establish_connection(db_login_info)
    end

    def insert_crawling_data_naver(data)
        db_naver = Crawling_naver.new(data)
        db_naver.save!
    end

    def insert_crawling_data_google(data)
        db_google = Crawling_google.new(data)
        db_google.save!
    end


    def insert_error(data)
        db_error = Crawling_error.new(data)
        db_error.save!
    end

    def insert_missing_job(data)
        db_missing_job = Crawling_missing_job.new(data)
        db_missing_job.save!
    end

    def restore_missing_jobs(start_time)
        index = 0
        keyword_list = Hash.new
        Crawling_missing_job.where(:start_time => start_time).select('keyword, is_done') do |job|
            puts job[:keyword].encoding
            keyword_list[job.keyword] = 1
            if job[:is_done] == 1
                index = index + 1
            end
        end
        return keyword_list, index
    end
end
