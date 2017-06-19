require 'rubygems'
require 'net/smtp'
require 'resolv'
require 'open-uri'
require 'uri'
require 'net/http'
require 'mail'

class Checker
	
	def initialize
		@website_list = []
		@good_websites = []
		@bad_websites = []
	end

	def tackle
		File.open(File.dirname(__FILE__) + '/listofurls.txt').each_line do |line|
  		@website_list << line.chomp
		end

		@website_list.each do |url|
   		begin
  		urls = URI.parse(url)
  		begin
    
  		req = Net::HTTP.new(urls.host, urls.port)
  		res = req.request_head(urls.path)
      
    	if res.code.to_i >= 200 && res.code.to_i < 400 
      	@good_websites << url
    	elsif res.code.to_i > 400
      	@bad_websites << url
      end
			
			rescue Timeout::Error
  			next
			end
			rescue Timeout::Error
  			next
			rescue SocketError
  			next
		end
	end

	if @bad_websites.length > 0
		puts "The broken list:"
		@bad_websites.each do |site|
			puts site
		end

  body_content = ""
  @bad_websites.each do |i|
    body_content += "#{i}"
  end
	
  Mail.defaults do
    delivery_method :sendmail
  end

  mail = Mail.new do
  	from    'michael@reunionmarketing.com'
  	to      'michael@reunionmarketing.com'
  	subject 'Some 404 Errors Exist'
  	body    body_content
	end

	mail.deliver!

	else
		puts "This mofo is empty."
  	puts Time.now
	end
end
end