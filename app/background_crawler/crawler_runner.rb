require 'nokogiri'
require 'net/http'
require 'logger'
require 'mysql2'

load 'database_manager.rb'

class CrawlerRunner

    def initialize(keyword_list, deny_list)
        @keyword_list = keyword_list
        @deny_list = deny_list
    end

    def run
        runner(DateTime.now.strftime('%Y-%m-%d %T'), make_keyword_list(@keyword_list, @deny_list), 0)
    end

    private
    #Must implement in sub class
    def runner(start_time, keyword_list, index)
        raise Exception
    end

    def save_missingjobs(db_manager, keyword_list, start_time, index)
        i = 0
        data = Hash.new
        data[:start_time] = start_time
        keyword_list.each do |key, value|
            i = i + 1
            data[:keyword] = key
            if i < index
                data[:is_done] = 1
                db_manager.insert_missing_job(data)
            else
                data[:is_done] = 0
                db_manager.insert_missing_job(data)
            end
        end
    end

    def is_denied_keyword(keyword, deny_list)
        flag = false
        deny_list.each { |deny_keyword|
            if keyword.strip.include? deny_keyword
                flag = true
                break
            end
        }
        flag
    end

    def make_keyword_list(keyword_list, deny_list)
        result = Hash.new
        keyword_list.each do |seed_keyword|
            if result.exclude? seed_keyword && !is_denied_keyword(seed_keyword, deny_list)
                result[seed_keyword.gsub(/\s+/, '')] = 1
            end
        end
        result
    end

    def make_db_login_info(db_login_info)
        login_info = Hash.new
        login_info[:adapter] = 'mysql2'
        login_info[:encoding] = 'utf8'
        File.open(db_login_info) do |fp|
            fp.each do |line|
                key, value = line.split("\s")
                login_info[key] = value
            end
        end
        login_info.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    end
end