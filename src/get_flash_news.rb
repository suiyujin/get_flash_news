require 'open-uri'
require 'nokogiri'

class GetFlashNews
  def initialize(flash_list_url = 'http://news.yahoo.co.jp/flash')
    @flash_list_url = flash_list_url
    @charset = nil
  end

  def parse_html
    html = open(@flash_list_url) do |f|
      @charset = f.charset
      f.read
    end

    @doc = Nokogiri::HTML.parse(html, nil, @charset)
  end

  def get_flash_urls(limit = 20)
    flash_urls = @doc.xpath('//div[@id="main"]//ul[@class="listBd"]/li/p/a/@href').map(&:text)
    flash_urls[0, limit]
  end

  def write_txt(limit = 20)
    result_file_name = "flash_urls_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.txt"
    File.open("#{File.expand_path(File.dirname(__FILE__)).sub(/src/, 'result')}/#{result_file_name}", 'w') do |result_file|
      get_flash_urls(limit).each { |url| result_file.puts(url) }
    end
  end
end
