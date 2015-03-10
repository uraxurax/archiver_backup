
require 'open-uri'
require 'json'

def get_archived_timestamp (url)
  json_url = 'http://archive.org/wayback/available?url=' + url
  res = open(json_url)
  list = JSON.parse(res.read)
  timestamp = list["archived_snapshots"]["closest"]["timestamp"] rescue nil
  if timestamp != nil
    timestamp = Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S UTC")
  end
  return timestamp
end

def need_archive? (url)
  need_archive = true
  timestamp = get_archived_timestamp(url)
  if timestamp != nil
    archived_time = Time.parse(timestamp)
    seven_days_before = Time.now.utc - 7 * (60 * 60 * 24)
    if archived_time > seven_days_before
      need_archive = false
    end
  end
  return need_archive
end

def get_archived_url (res, url)
  archived_url = nil
  res.each {|line|
    if line.include?(url) && line.include?("var redirUrl")
      if /"(\/web\/.+?)"/ =~ line
        archived_url = 'https://web.archive.org' + $1
      end
    end
  }
  return archived_url
end

def try_archive (url)
  puts "request url = " + url
  archived_url = nil
  if need_archive? url
    save_url = 'http://web.archive.org/save/' + url
    res = open(save_url)
    archived_url = get_archived_url(res, url)
  end
  if archived_url != nil
    puts "archived_url = " + archived_url
  end
  return archived_url
end
  

#url = 'https://www.homes.co.jp/tochi/b-1242640001746/'
#url = 'https://www.homes.co.jp/tochi/b-84620002329/'
#url = 'https://www.homes.co.jp/tochi/b-12426400017468/'
#url = 'https://www.homes.co.jp/tochi/b-1007450007456/'
#url = 'https://www.homes.co.jp/tochi/b-1041390003822/'
#url = 'https://www.homes.co.jp/tochi/b-1041390004865/'
#url = 'https://www.homes.co.jp/tochi/b-1041390005165/'
#url = 'https://www.homes.co.jp/tochi/b-1041390005436/'
#url = 'https://www.homes.co.jp/tochi/b-1041390005466/'
#url = 'https://www.homes.co.jp/tochi/b-1041390005467/'
#url = 'https://www.homes.co.jp/tochi/b-1072650049157/'
#url = 'https://www.homes.co.jp/tochi/b-1072650052787/'
#url = 'https://www.homes.co.jp/tochi/b-1072650052788/'
#url = 'https://www.homes.co.jp/tochi/b-1113280008021/'
#url = 'https://www.homes.co.jp/tochi/b-1113280012979/'
#url = 'https://www.homes.co.jp/tochi/b-1130650000166/'
#url = 'https://www.homes.co.jp/tochi/b-1150440006442/'
#url = 'https://www.homes.co.jp/tochi/b-1161840005320/'
#url = 'https://www.homes.co.jp/tochi/b-1161840027330/'
#url = 'https://www.homes.co.jp/tochi/b-1161840027331/'
#url = 'https://www.homes.co.jp/tochi/b-1161840028531/'
#url = 'https://www.homes.co.jp/tochi/b-1178170000104/'
#url = 'https://www.homes.co.jp/tochi/b-1195640001170/'
#url = 'https://www.homes.co.jp/tochi/b-12070010171/'
#url = 'https://www.homes.co.jp/tochi/b-1239400000013/'
#url = 'https://www.homes.co.jp/tochi/b-1240300000934/'
#url = 'https://www.homes.co.jp/tochi/b-1242640001746/'
#url = 'https://www.homes.co.jp/tochi/b-1242640002229/'
url = 'https://www.homes.co.jp/tochi/b-1260470000016/'



try_archive url
