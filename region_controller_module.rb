# -*- coding: utf-8 -*-


module RegionControllerModule
  @@pref_info = {
    :saitama => [:saitama_nishiku, :warabi],
  }
  private
  def prefecture?(prefecture)
    @@pref_info.has_key?(prefecture)
  end

  def get_cities_from_prefecture(prefecture)
    puts @@pref_info[prefecture]
    @@pref_info[prefecture]
  end
  
  def city?(region)
    city = false
    @@pref_info.each {|key, value|
      city = true if value.include?(region)
    }
    city
  end
  public
  def get_city_list(regions)
    city_list = []
    regions.each { |region|
      city_list.concat(get_cities_from_prefecture(region)) if prefecture?(region)
      city_list.push(region) if city?(region)
    }
    city_list
  end
  
end
