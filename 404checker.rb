#https://github.com/javan/whenever
#https://jerodsanto.net/2009/08/self-scheduling-ruby-scripts/
#https://stackoverflow.com/questions/30719471/how-to-check-if-whenever-gem-is-working
#https://stackoverflow.com/questions/6566884/rubys-file-open-gives-no-such-file-or-directory-text-txt-errnoenoent-er
#https://stackoverflow.com/questions/18328173/using-whenever-gem-for-scheduling-a-job-every-hour-on-sunday
#http://eewang.github.io/blog/2013/03/12/how-to-schedule-tasks-using-whenever/

require 'rubygems'
require 'net/smtp'
require 'resolv'
require 'open-uri'
require 'uri'
require 'net/http'
require 'mail'

website_list = []

File.open(File.dirname(__FILE__) + '/listofurls.txt').each_line do |line|
  website_list << line.chomp
end

good_websites = []
bad_websites = []

website_list.each do |url|
   begin
    urls = URI.parse(url)
    begin
    req = Net::HTTP.new(urls.host, urls.port)
    res = req.request_head(urls.path)
      if res.code.to_i >= 200 && res.code.to_i < 400 
        good_websites << url
      elsif res.code.to_i > 400
        bad_websites << url
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

if bad_websites.length > 0
	puts "The broken list:"
	bad_websites.each do |site|
		puts site
	end

  body_content = ""
  bad_websites.each do |i|
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