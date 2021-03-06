require 'nokogiri'
require 'net/http'

load 'crawler_runner.rb'

class CrawlerRunnerGoogle < CrawlerRunner

    def initialize(keyword_list, deny_list, company_list,  db_login_info_file)
        super(keyword_list, deny_list)
        @deny_list = deny_list
        @company_list = company_list
        @db_login_info_file = db_login_info_file
        make_logger
    end

    def runner(start_time, keyword_list, index)
        @logger.info('----- Stargt Google Crawling -----')
        parser = HtmlParser.new('https://www.google.co.kr/search?q=')
        db_manager = DatabaseManager.new(make_db_login_info(@db_login_info_file))
        error_info = Hash.new
        count_db = 0
        index = 0
        db_manager.set_running('google')
        while keyword_list.length > index do
            begin
                unless db_manager.is_running('google')
                    puts 'stop crawling'
                    break
                end
                current_keyword = keyword_list.keys[index]
                relate_value = keyword_list.values[index]

                puts current_keyword

                @logger.info("------------- Start '#{current_keyword}' ---------------")
                @logger.info("Hash Size -> '#{keyword_list.length}'")
                current_page = parser.make_page(current_keyword, true, make_header)
                ad_info =  parser.get_adlink_info_google(current_page, @company_list)
                puts ad_info
                is_valuable = ad_info.values.include? 1

                ad_info[:crawling_time] = DateTime.now.strftime('%Y-%m-%d %T')
                ad_info[:start_time] = start_time
                ad_info[:keyword] = current_keyword

                related_keyword = parser.get_related_keywords(current_page, @deny_list, 'p._e4b')

                if is_valuable
                    unless is_denied_keyword(current_keyword, @deny_list)
                        db_manager.insert_crawling_data_google(ad_info)
                        @logger.info("Insert DB '#{current_keyword}'")
                        count_db = count_db + 1
                    end

                    related_keyword.each do |keyword|
                        unless keyword_list.has_key? keyword
                            keyword_list[keyword] = 1
                        end
                    end
                elsif relate_value > 0
                    related_keyword.each do |keyword|
                        unless keyword_list.has_key? keyword
                            keyword_list[keyword] = relate_value - 1
                        end
                    end
                end

                index = index + 1
                sleep_policy(index, keyword_list.size)
            rescue SystemExit, Interrupt
                @logger.warn('Crawler SystemExit, Interrupt')
                raise
            rescue Exception => e
                @logger.error("Crawler Exception #{e}, #{e.backtrace}")
                puts "#{e}, #{e.backtrace}"
                if e.to_s.include? '403'
                    @logger.error("403 HTTP Request, Stop Crawling, #{e}, #{e.backtrace}")
                end

                error_info[:start_time] = start_time
                error_info[:error_time] = DateTime.now.strftime('%Y-%m-%d %T')
                error_info[:keyword] = current_keyword
                error_info[:error_msg] = "#{e}, #{e.backtrace}"
                db_manager.insert_error(error_info)
                break
            end
        end
    end

    def sleep_policy(index, keyword_size)
        if index % 50 == 0
            @logger.info("index -> #{index}, keyword size -> #{keyword_size}")
            sleep(20 + rand(20))
        elsif index % 501 == 0
            @logger.info("index -> #{index}, keyword size -> #{keyword_size}")
            sleep(300 + rand(50))
        else
            sleep(2 + rand(2))
        end
    end


    def make_header
        if rand(2) == 0
            accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
        else
            accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        end

        if rand(2) == 0
            user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
        else
            user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:34.0) Gecko/20100101 Firefox/34.0'
        end

        headers = { 'Accept' => accept,
                    'Accept-Language' => 'ko-kr,ko;q=0.8,en-us;q=0.5,en;q=0.3',
                    'Connection' => 'keep-alive',
                    'Host' => 'www.google.co.kr',
                    'User-Agent' => user_agent}
        headers
    end

    def make_logger
        @logger = Logger.new("./log/google_#{DateTime.now.strftime('%Y-%m-%d')}.log", 'daily')
        @logger.level = Logger::INFO
        @logger
    end
end
