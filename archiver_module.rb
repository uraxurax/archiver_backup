require 'open-uri'
require 'json'

module ArchiverModule
  public
  def try_archive (url)
    archived_url = nil
    if need_archive? url
      save_url = 'http://web.archive.org/save/' + url
      res = open(save_url)
      archived_url = get_archived_url(res, url)
    end
    archived_url
  end
  private
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
    need_archive
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
    archived_url
  end
  
  def get_archived_timestamp (url)
    json_url = 'http://archive.org/wayback/available?url=' + url
    res = open(json_url)
    list = JSON.parse(res.read)
    timestamp = list["archived_snapshots"]["closest"]["timestamp"] rescue nil
    if timestamp != nil
      timestamp = Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S UTC")
    end
    timestamp
  end
end
