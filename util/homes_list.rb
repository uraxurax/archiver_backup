# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'

opts = {
  :depth_limit => 0,
  :delay => 1
}
max_length = 0
length = 0
list_pages = [
  'http://www.homes.co.jp/tochi/tokyo/city/',
  'http://www.homes.co.jp/tochi/kanagawa/city/',
  'http://www.homes.co.jp/tochi/saitama/city/',
  'http://www.homes.co.jp/tochi/chiba/city/',
]

data_lists = []
city_lists = []

list_pages.each {|list_page|
  /tochi\/(.*?)\/city\// =~ list_page
  pref = $1
  cities = []
  pref_cities = []
  pref_cities.push(pref)
  
  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      num = 0
      links.each{|link|
        if /http:\/\/www.homes.co.jp\/tochi\/#{pref}\/(.*?)-city\/list\// =~ link.to_s
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

data_lists.each { |pref_cities|
  pref = pref_cities[0];
  cities = pref_cities[1];
  puts '' 
  cities.each{|city|
    print(":" + city)
    space_count = length - city.length()
    space_count.times {
      print(" ")
    }
    print(" => \"")
    print("#{pref}/#{city}-city\",\n")    
  }
  puts 
}

