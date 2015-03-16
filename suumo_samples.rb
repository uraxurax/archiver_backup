
require 'date'
require './suumo_archiver'
require './archiver_module'

include ArchiverModule


opts = {
#  :proxy_host => 'localhost',
#  :proxy_port => '5432',
}


pref_list = [:saitama]
site = "suumo"

suumo_archiver = SuumoArchiver.new(opts)

date = Date::today

pref_list.each{|pref|
  pref_prop_file = "#{File.expand_path('../data',__FILE__)}/#{site}_#{pref.to_s}_prop_list_#{date.to_s}.txt"
  pref_arch_file = "#{File.expand_path('../data',__FILE__)}/#{site}_#{pref.to_s}_arch_list_#{date.to_s}.txt"

  city_list = suumo_archiver.get_city_list(pref)
  p city_list
  city_list.each{|city|
    arch_urls = []
    
    prop_urls = suumo_archiver.get_prop_urls_from_city(city)
    prop_urls.each{|prop_url|
      archived_url = try_archive(prop_url)
      unless archived_url == nil
        arch_urls.push(archived_url) 
        sleep(1)
      end
    }
  }
}
