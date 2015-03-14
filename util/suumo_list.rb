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

list_pages.each {|list_page|
  puts '' 
  /tochi\/(.*?)\// =~ list_page
  pref = $1
  print(":" + pref + " => [")
  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      num = 0
      links.each{|link|
        if /http:\/\/suumo.jp\/tochi\/(.*?\/sc_.*?)\// =~ link.to_s
          link_parts = $1
          if /sc_(.*)/ =~ link_parts
            city = $1
            if city.length() > max_length
              max_length = city.length()
            end
            print(", ") if (num != 0)
            print(":" + city)
            num = num+1
          end
        end
      }
    end
  end
  print("],")
#  puts max_length
}

length = max_length

list_pages.each {|list_page|
  puts ''
  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if /http:\/\/suumo.jp\/tochi\/(.*?\/sc_.*?)\// =~ link.to_s
          link_parts = $1
          if /sc_(.*)/ =~ link_parts
            city = $1
            if (city.length() > max_length)
              max_length = city.length()
            end
            print(":" + city)
            space_count = length - city.length()
            space_count.times {
              print(" ")
            }
            print(" => \"")
            puts link_parts + "\","
          end
        end
      }
    end
  end
#  puts max_length
}
