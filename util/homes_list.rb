# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'

opts = {
  :proxy_host => 'localhost',
  :proxy_port => '5432',
  :depth_limit => 0,
  :delay => 1
}
max_length = 0
length = 25
list_pages = [
  'http://www.homes.co.jp/tochi/tokyo/city/',
  'http://www.homes.co.jp/tochi/kanagawa/city/',
  'http://www.homes.co.jp/tochi/saitama/city/',
  'http://www.homes.co.jp/tochi/chiba/city/',
]

list_pages.each {|list_page|
  puts ''
  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if /http:\/\/www.homes.co.jp\/tochi\/(.*?\/)list\// =~ link.to_s
          link_parts = $1
          if /.*?\/(.*?)-city/ =~ link_parts
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
