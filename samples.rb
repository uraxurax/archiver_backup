require './homes_archiver'


opts = {
  :proxy_host => 'localhost',
  :proxy_port => '5432',
}
#url = "http://www.homes.co.jp/tochi/saitama/warabi-city/list/"

#page_urls = get_page_urls(url, opts);
#page_urls.each{|url|
#  puts url;
#}

#prop_urls = get_prop_urls(page_urls, opts)
#prop_urls.each{|url|
#  puts url;
#}


homes_archiver = HomesArchiver.new(opts)

#prop_urls = homes_archiver.get_prop_urls_from_regions([:warabi])
prop_urls = homes_archiver.get_prop_urls_from_regions([:saitama_nishiku])
#prop_urls = homes_archiver.get_prop_urls_from_regions([:saitama])
puts prop_urls.length
prop_urls.each {|prop_url|
  p prop_url
}

#PR
#//*[@id="kksframelist"]/div[1]/div[1]/div[1]/h3/a

#normal
#//*[@id="prg-mod-bukkenList"]/div[2]/div[2]/div[1]/div[2]/div[1]/h3/a
