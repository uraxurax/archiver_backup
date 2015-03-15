
require 'date'
require './homes_archiver'
require './archiver_module'

include ArchiverModule


opts = {
#  :proxy_host => 'localhost',
#  :proxy_port => '5432',
}

pref_list = [:tokyo, :kanagawa, :saitama, :chiba]
site = "homes"

homes_archiver = HomesArchiver.new(opts)

date = Date::today


pref_list.each{|pref|
  pref_prop_file = "#{File.expand_path('../data',__FILE__)}/#{site}_#{pref.to_s}_prop_list_#{date.to_s}.txt"
  pref_arch_file = "#{File.expand_path('../data',__FILE__)}/#{site}_#{pref.to_s}_arch_list_#{date.to_s}.txt"
  
  city_list = get_city_list(pref)
  city_list.each{|city|
    puts city
    arch_urls = []
    
    prop_urls = homes_archiver.get_prop_urls_from_city(city)
    prop_urls.each{|prop_url|
      archived_url = try_archive(prop_url)
      unless archived_url == nil
        arch_urls.push(archived_url) 
        sleep(1)
      end
    }
    puts "prop_urls.length() = " + prop_urls.length().to_s
    File.open(pref_prop_file, "a") do |file|
      file.write(city.to_s + ":" + Time.now().to_s + "\n")
      prop_urls.each{ |prop_url|
        file.write(prop_url + "\n")
      }
    end
    puts "arch_urls.length() = " + arch_urls.length().to_s
    File.open(pref_arch_file, "a") do |file|
      file.write(city.to_s + ":" + Time.now().to_s + "\n")
      arch_urls.each{ |arch_url|
        file.write(arch_url + "\n")
      }
    end
  }
}
#end
#File.open(stderr_file, "a") do |file|
#  file.write(cstderr)
#end
