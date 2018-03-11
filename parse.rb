require 'bundler'
Bundler.require
require 'open-uri'

doc = Nokogiri::HTML.parse(open('https://ja.wikipedia.org/wiki/%E3%81%8B%E3%81%BF%E3%81%95%E3%81%BE%E3%81%BF%E3%81%AA%E3%82%89%E3%81%84_%E3%83%92%E3%83%9F%E3%83%84%E3%81%AE%E3%81%93%E3%81%93%E3%81%9F%E3%81%BE').read)
first_line = true
series_year = [nil, 2015, 2016, 2016, 2017, 2017, 2018, 2018]
(1..doc.xpath("//*[@class=\"NavFrame\"]").size).each do |series|
  (2..doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr").size).each do |e|
    if doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr[#{e}]/td").size >= 5
      # Aパート(放送日と第何話かも込み)
      print "\n" unless first_line
      first_line = false
      date = "#{series_year[series]}-"
      date += doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr[#{e}]/td[1]").first.text
      date.sub!('月', '-')
      print Date.parse(date)
      print ","
      print doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr[#{e}]/td[2]").first.text
      print ",\""
      print doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr[#{e}]/td[3]").first.text
      print "\""
    else
      # Bパート
      print ",\""
      print doc.xpath("//*[@class=\"NavFrame\"][#{series}]/div[2]/table/tr[#{e}]/td[1]").first.text
      print "\""
    end
  end
end
print "\n"
