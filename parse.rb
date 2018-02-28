require 'bundler'
Bundler.require
require 'open-uri'

doc = Nokogiri::HTML.parse(open('https://ja.wikipedia.org/wiki/%E3%81%8B%E3%81%BF%E3%81%95%E3%81%BE%E3%81%BF%E3%81%AA%E3%82%89%E3%81%84_%E3%83%92%E3%83%9F%E3%83%84%E3%81%AE%E3%81%93%E3%81%93%E3%81%9F%E3%81%BE').read)
first_line = true
series_year = [nil, 2015, 2016, 2017, 2017, 2018, 2018]
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

# Chromeの開発者ツールで得られたXPath
# //*[@id="NavFrame1"]/div[2]/table/tbody/tr[2]/td[3] # 1話Aパート (第1シリーズ2015年) 誕生!小さな神様
# //*[@id="NavFrame2"]/div[2]/table/tbody/tr[2]/td[3] # 14話Aパート (第1シリーズ2016年)
# //*[@id="NavFrame2"]/div[2]/table/tbody/tr[3]/td    # 14話Bパート
# //*[@id="NavFrame3"]/div[2]/table/tbody/tr[2]/td[3] # 64話Aパート (第1シリーズ2017年)
# //*[@id="NavFrame4"]/div[2]/table/tbody/tr[2]/td[3] # 77話Aパート (第2シリーズ2017年)
# 実際に有効なXPath
# //*[@class="NavFrame"][1]/div[2]/table/tr[2]/td[3] # 1話Aパート (第1シリーズ2015年) 誕生!小さな神様
# //*[@class="NavFrame"][1]/div[2]/table/tr[3]/td[1] # 1話Bパート                     こころ、家をたてる!?
# //*[@class="NavFrame"][2]/div[2]/table/tr[2]/td[3] # 14話Aパート (第1シリーズ2016年) アワッと登場!双子のここたま
# //*[@class="NavFrame"][2]/div[2]/table/tr[3]/td[1] # 14話Bパート                     サリーヌとパリーヌの秘密
# //*[@class="NavFrame"][3]/div[2]/table/tr[2]/td[3] # 64話Aパート (第1シリーズ2017年) ここたまの初夢パニック
# //*[@class="NavFrame"][4]/div[2]/table/tr[2]/td[3] # 77話Aパート (第2シリーズ2017年) 春のウキウキ♪ここたま活動
