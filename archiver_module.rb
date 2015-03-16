require 'uri'
require 'open-uri'
require 'json'

module ArchiverModule
  public
  def try_archive (url)
    puts "try_archive #{url}"
    archived_url = nil
    if need_archive? url
      archived_url = get_archived_url(url)
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

  def get_archived_url (url)
    save_url = 'http://web.archive.org/save/' + url
    archived_url = nil
    res = retry_open(save_url)
    if res != nil
      uri = URI(url)
      res.each {|line|
        if line.include?(uri.host) && line.include?("var redirUrl")
          if /"(\/web\/.+?)"/ =~ line
            archived_url = 'https://web.archive.org' + $1
          end
        end
      }
    end
    archived_url
  end
  
  def get_archived_timestamp (url)
    json_url = 'http://archive.org/wayback/available?url=' + url
    res = retry_open(json_url)
    
    list = JSON.parse(res.read)
    timestamp = list["archived_snapshots"]["closest"]["timestamp"] rescue nil
    if timestamp != nil
      timestamp = Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S UTC")
    end
    timestamp
  end
  def retry_open(url)
    res = rescue_open(url)
    if res != nil
      code, message = res.status #res.status => ["200", "OK"]
      
      until code == '200'
        puts "OMG!! #{code} #{message} url = #{json_url}"
        sleep(60)
        res = rescue_open(url)
        code, message = res.status #res.status => ["200", "OK"]
      end
    end
    res
  end
  
  def rescue_open(url)
    res = open(url)
  rescue OpenURI::HTTPError => e
    print "error raise in rescue: "
    p e
    print "url = #{url}\n"
    the_status = e.io.status[0]
    unless the_status.to_i == 404 then
      retry
    else
      res = nil
    end
  rescue => e
    print "error raise in rescue: "
    p e
    print "url = #{url}"
  ensure
    res
  end
end
