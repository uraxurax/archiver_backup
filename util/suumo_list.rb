# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'

opts = {
#  :proxy_host => 'localhost',
#  :proxy_port => '5432',
  :depth_limit => 0,
  :delay => 1
}
max_length = 0
length = 0
list_pages = [
  'http://suumo.jp/tochi/tokyo/',
  'http://suumo.jp/tochi/kanagawa/',
  'http://suumo.jp/tochi/saitama/',
  'http://suumo.jp/tochi/chiba/',
]
data_lists = []
city_lists = []

list_pages.each {|list_page|
  pref_cities = []
  cities = []
  /tochi\/(.*?)\// =~ list_page
  pref = $1
  pref_cities.push(pref)

  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      num = 0
      links.each{|link|
        if /http:\/\/suumo.jp\/tochi\/#{pref}\/sc_(.*?)\// =~ link.to_s
          city = $1
          cities.push(city)
          if city.length() > max_length
            max_length = city.length()
          end
        end
      }
    end
  end
  cities.uniq!()

  pref_cities.push(cities)
  data_lists.push(pref_cities)
}

length = max_length

data_lists.each { |pref_cities|
  pref = pref_cities[0];
  cities = pref_cities[1];

  print(":" + pref + " => [")
  num = 0
  cities.each{|city|
    print(", ") if (num != 0)
    print(":" + city)
    num = num+1
  }
  print("],")
}

puts
puts

data_lists.each { |pref_cities|
  pref = pref_cities[0];
  cities = pref_cities[1];

  cities.each{|city|
    print(":" + city)
    space_count = length - city.length()
    space_count.times {
      print(" ")
    }
    print(" => \"")
    print("#{pref}/sc_#{city}\",\n")    
  }
  puts 
}
