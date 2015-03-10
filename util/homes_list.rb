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


list_pages = [
  'http://www.homes.co.jp/tochi/tokyo/city/',
  'http://www.homes.co.jp/tochi/kanagawa/city/',
  'http://www.homes.co.jp/tochi/saitama/city/',
  'http://www.homes.co.jp/tochi/chiba/city/',
]

list_pages.each {|list_page|
  puts ''
  base_urls = []
  Anemone.crawl(list_page, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if /http:\/\/www.homes.co.jp\/tochi\/(.*?\/)list\// =~ link.to_s
          base_urls.push($1)
        end
      }
    end
  end
  base_urls.each {|base_url|
    puts base_url
  }
}
