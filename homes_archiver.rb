# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'
require './region_controller_module'


class HomesArchiver
  include RegionControllerModule

  @@city2url = {
    #Saitama-Prefecture
    :saitama_nishiku  => "saitama/saitama_nishi-city/",
    :saitama_kitaku   => "saitama/saitama_kita-city/",
    :saitama_omiya    => "saitama/saitama_omiya-city/",
    :saitama_chuo     => "saitama/saitama_chuo-city/",
    :saitama_sakura   => "saitama/saitama_sakura-city/",
    :saitama_urawa    => "saitama/saitama_urawa-city/",
    :saitama_minami   => "saitama/saitama_minami-city/",
    :saitama_midori   => "saitama/saitama_midori-city/",
    :saitama_iwatsuki => "saitama/saitama_iwatsuki-city/",
    :kawagoe          => "saitama/kawagoe-city/",
    :kumagaya         => "saitama/kumagaya-city/",
    :warabi           => "saitama/warabi-city/"
  }
    
  def initialize(opts={})
    opts[:depth_limit] = 0 unless opts.has_key?(:depth_limit)
    opts[:delay] = 1 unless opts.has_key?(:delay)
    @opts = opts
  end

  def get_prop_urls_from_regions(regions)
    prop_urls = []
    city_list = get_city_list(regions)
    city_list.each {|city|
      prop_urls.concat(get_prop_urls_from_city(city))
    }
    prop_urls
  end

  def get_prop_urls_from_city(city)
    prop_urls = []
    prop_urls_list_pages = get_prop_urls_list_pages(city)
    prop_urls_list_pages.each {|list_page|
      prop_urls.concat(get_prop_urls_from_list_page(list_page))
    }
    prop_urls.sort!
    prop_urls.uniq!
    prop_urls
  end

  def get_prop_urls_list_pages(city)
    list_pages = []
    base_url = get_base_url(city)

    doc = Nokogiri::HTML(open(base_url))
    prop_num = doc.xpath('//*[@id="searchResult"]/div[3]/div/p/span/span').text.to_i
    
    num = 0
    while num*30 < prop_num do
      num += 1
      list_pages.push(base_url + '?page=' + num.to_s)
    end
    list_pages
  end

  def get_prop_urls_from_list_page(list_page)
  prop_urls = []
  Anemone.crawl(list_page, @opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if link.to_s.include?("https://www.homes.co.jp/tochi/b-")
          prop_urls.push(link.to_s)
        end
      }
    end
  end
  prop_urls.sort!
  prop_urls.uniq!
  prop_urls
  end
  def get_base_url(city)
    'http://www.homes.co.jp/tochi/' + @@city2url[city] + 'list/'
  end
end




def get_page_urls(url_base, opts)
  page_urls = []
  opts[:depth_limit]=0
  Anemone.crawl(url_base, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if link.to_s.include?(url_base)
          page_urls.push(link.to_s)
        end
      }
    end
  end
  page_urls.sort!
  page_urls.uniq!
  return page_urls;
end

def get_prop_urls(page_urls, opts)
  prop_urls = []
  opts[:depth_limit]=0
  Anemone.crawl(page_urls, opts) do |anemone|
    anemone.on_every_page do |page|
      links = page.links()
      links.each{|link|
        if link.to_s.include?("https://www.homes.co.jp/tochi/b-")
          prop_urls.push(link.to_s)
        end
      }
    end
  end
  prop_urls.sort!
  prop_urls.uniq!
  return prop_urls
end


=begin
     :kawaguchi        => "saitama//",
     :gyoda        => "saitama//",
     :chichibu        => "saitama//",
     :tokorozawa        => "saitama//",
     :hanno        => "saitama//",
     :kazo        => "saitama//",
     :honjyo        => "saitama//",
=end
