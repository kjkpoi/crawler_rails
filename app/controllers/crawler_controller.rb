class CrawlerController < ApplicationController
	def index
	end

	def new
	end

	def create
		crawler_name = case params[:type]
			when "naver_cpc" then "CrawlerNaver"
			when "google_cpc" then "CrawlerGoogle"
			else rasie Exception
		end
	
		respond_to do |format|
			if Resque.enqueue(crawler_name.constantize, params)
				format.html { redirect_to action: 'index'}
			else
				format.html { render :create }
			end
		end
	end

	def download
		@crawling_google = CrawlingGoogle.all
		@crawling_naver = CrawlingNaver.all
		respond_to do |format|
			format.html
			format.csv {
				case params[:crawling_type]
				when 'google'
					send_data(@crawling_google.where(start_time: params[:start_time]).to_csv, :type => 'text/csv; charset=iso-8859-1; ')
				when 'naver'
					send_data(@crawling_naver.where(start_time: params[:start_time]).to_csv)
				else
					raise 'crawling_type error'
				end
			}
		end
	end

	def manager
		if params[:commit] == 'stop'
			crawling_stop = CrawlingStop.find_by(crawler_name: params[:type])
			crawling_stop[:current_status] = 'STOP'
			crawling_stop.save!
		end
	end
end
