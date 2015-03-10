# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'


class HomesArchiver
  @@city2url = {
    #Tokyo
    :chiyoda                   => "tokyo/chiyoda-city/",
    :chuo                      => "tokyo/chuo-city/",
    :minato                    => "tokyo/minato-city/",
    :shinjuku                  => "tokyo/shinjuku-city/",
    :bunkyo                    => "tokyo/bunkyo-city/",
    :taito                     => "tokyo/taito-city/",
    :sumida                    => "tokyo/sumida-city/",
    :koto                      => "tokyo/koto-city/",
    :shinagawa                 => "tokyo/shinagawa-city/",
    :meguro                    => "tokyo/meguro-city/",
    :ota                       => "tokyo/ota-city/",
    :setagaya                  => "tokyo/setagaya-city/",
    :shibuya                   => "tokyo/shibuya-city/",
    :nakano                    => "tokyo/nakano-city/",
    :suginami                  => "tokyo/suginami-city/",
    :toshima                   => "tokyo/toshima-city/",
    :kita                      => "tokyo/kita-city/",
    :arakawa                   => "tokyo/arakawa-city/",
    :itabashi                  => "tokyo/itabashi-city/",
    :nerima                    => "tokyo/nerima-city/",
    :adachi                    => "tokyo/adachi-city/",
    :katsushika                => "tokyo/katsushika-city/",
    :edogawa                   => "tokyo/edogawa-city/",
    :hachioji                  => "tokyo/hachioji-city/",
    :tachikawa                 => "tokyo/tachikawa-city/",
    :musashino                 => "tokyo/musashino-city/",
    :mitaka                    => "tokyo/mitaka-city/",
    :ome                       => "tokyo/ome-city/",
    :fuchu                     => "tokyo/fuchu-city/",
    :akishima                  => "tokyo/akishima-city/",
    :chofu                     => "tokyo/chofu-city/",
    :machida                   => "tokyo/machida-city/",
    :koganei                   => "tokyo/koganei-city/",
    :kodaira                   => "tokyo/kodaira-city/",
    :hino                      => "tokyo/hino-city/",
    :higashimurayama           => "tokyo/higashimurayama-city/",
    :kokubunji                 => "tokyo/kokubunji-city/",
    :kunitachi                 => "tokyo/kunitachi-city/",
    :fussa                     => "tokyo/fussa-city/",
    :komae                     => "tokyo/komae-city/",
    :higashiyamato             => "tokyo/higashiyamato-city/",
    :kiyose                    => "tokyo/kiyose-city/",
    :higashikurume             => "tokyo/higashikurume-city/",
    :musashimurayama           => "tokyo/musashimurayama-city/",
    :tama                      => "tokyo/tama-city/",
    :inagi                     => "tokyo/inagi-city/",
    :hamura                    => "tokyo/hamura-city/",
    :akiruno                   => "tokyo/akiruno-city/",
    :nishitokyo                => "tokyo/nishitokyo-city/",
    :nishitama_mizuho          => "tokyo/nishitama_mizuho-city/",
    :nishitama_hinode          => "tokyo/nishitama_hinode-city/",
    :nishitama_hinohara        => "tokyo/nishitama_hinohara-city/",
    :nishitama_okutama         => "tokyo/nishitama_okutama-city/",
    :tokyo13360                => "tokyo/13360-city/",
    :oshima                    => "tokyo/oshima-city/",
    :tokyo13362                => "tokyo/13362-city/",
    :niijima                   => "tokyo/niijima-city/",
    :kozushima                 => "tokyo/kozushima-city/",
    :tokyo13380                => "tokyo/13380-city/",
    :miyake                    => "tokyo/miyake-city/",
    :mikurajima                => "tokyo/mikurajima-city/",
    :tokyo13400                => "tokyo/13400-city/",
    :hachijo                   => "tokyo/hachijo-city/",
    :aogashima                 => "tokyo/aogashima-city/",
    :tokyo13420                => "tokyo/13420-city/",
    :ogasawara                 => "tokyo/ogasawara-city/",

    #Kanagawa
    :yokohama_tsurumi          => "kanagawa/yokohama_tsurumi-city/",
    :yokohama_kanagawa         => "kanagawa/yokohama_kanagawa-city/",
    :yokohama_nishi            => "kanagawa/yokohama_nishi-city/",
    :yokohama_naka             => "kanagawa/yokohama_naka-city/",
    :yokohama_minami           => "kanagawa/yokohama_minami-city/",
    :yokohama_hodogaya         => "kanagawa/yokohama_hodogaya-city/",
    :yokohama_isogo            => "kanagawa/yokohama_isogo-city/",
    :yokohama_kanazawa         => "kanagawa/yokohama_kanazawa-city/",
    :yokohama_kohoku           => "kanagawa/yokohama_kohoku-city/",
    :yokohama_totsuka          => "kanagawa/yokohama_totsuka-city/",
    :yokohama_konan            => "kanagawa/yokohama_konan-city/",
    :yokohama_asahi            => "kanagawa/yokohama_asahi-city/",
    :yokohama_midori           => "kanagawa/yokohama_midori-city/",
    :yokohama_seya             => "kanagawa/yokohama_seya-city/",
    :yokohama_sakae            => "kanagawa/yokohama_sakae-city/",
    :yokohama_izumi            => "kanagawa/yokohama_izumi-city/",
    :yokohama_aoba             => "kanagawa/yokohama_aoba-city/",
    :yokohama_tsuzuki          => "kanagawa/yokohama_tsuzuki-city/",
    :kawasaki_kawasaki         => "kanagawa/kawasaki_kawasaki-city/",
    :kawasaki_saiwai           => "kanagawa/kawasaki_saiwai-city/",
    :kawasaki_nakahara         => "kanagawa/kawasaki_nakahara-city/",
    :kawasaki_takatsu          => "kanagawa/kawasaki_takatsu-city/",
    :kawasaki_tama             => "kanagawa/kawasaki_tama-city/",
    :kawasaki_miyamae          => "kanagawa/kawasaki_miyamae-city/",
    :kawasaki_asao             => "kanagawa/kawasaki_asao-city/",
    :sagamihara_midori         => "kanagawa/sagamihara_midori-city/",
    :sagamihara_chuo           => "kanagawa/sagamihara_chuo-city/",
    :sagamihara_minami         => "kanagawa/sagamihara_minami-city/",
    :yokosuka                  => "kanagawa/yokosuka-city/",
    :hiratsuka                 => "kanagawa/hiratsuka-city/",
    :kamakura                  => "kanagawa/kamakura-city/",
    :fujisawa                  => "kanagawa/fujisawa-city/",
    :odawara                   => "kanagawa/odawara-city/",
    :chigasaki                 => "kanagawa/chigasaki-city/",
    :zushi                     => "kanagawa/zushi-city/",
    :miura                     => "kanagawa/miura-city/",
    :hadano                    => "kanagawa/hadano-city/",
    :atsugi                    => "kanagawa/atsugi-city/",
    :yamato                    => "kanagawa/yamato-city/",
    :isehara                   => "kanagawa/isehara-city/",
    :ebina                     => "kanagawa/ebina-city/",
    :zama                      => "kanagawa/zama-city/",
    :minamiashigara            => "kanagawa/minamiashigara-city/",
    :ayase                     => "kanagawa/ayase-city/",
    :miura_hayama              => "kanagawa/miura_hayama-city/",
    :koza_samukawa             => "kanagawa/koza_samukawa-city/",
    :naka_oiso                 => "kanagawa/naka_oiso-city/",
    :naka_ninomiya             => "kanagawa/naka_ninomiya-city/",
    :ashigarakami_nakai        => "kanagawa/ashigarakami_nakai-city/",
    :ashigarakami_oi           => "kanagawa/ashigarakami_oi-city/",
    :ashigarakami_matsuda      => "kanagawa/ashigarakami_matsuda-city/",
    :ashigarakami_yamakita     => "kanagawa/ashigarakami_yamakita-city/",
    :ashigarakami_kaisei       => "kanagawa/ashigarakami_kaisei-city/",
    :ashigarashimo_hakone      => "kanagawa/ashigarashimo_hakone-city/",
    :ashigarashimo_manazuru    => "kanagawa/ashigarashimo_manazuru-city/",
    :ashigarashimo_yugawara    => "kanagawa/ashigarashimo_yugawara-city/",
    :aiko_aikawa               => "kanagawa/aiko_aikawa-city/",
    :aiko_kiyokawa             => "kanagawa/aiko_kiyokawa-city/",

    #Saitama
    :saitama_nishi             => "saitama/saitama_nishi-city/",
    :saitama_kita              => "saitama/saitama_kita-city/",
    :saitama_omiya             => "saitama/saitama_omiya-city/",
    :saitama_minuma            => "saitama/saitama_minuma-city/",
    :saitama_chuo              => "saitama/saitama_chuo-city/",
    :saitama_sakura            => "saitama/saitama_sakura-city/",
    :saitama_urawa             => "saitama/saitama_urawa-city/",
    :saitama_minami            => "saitama/saitama_minami-city/",
    :saitama_midori            => "saitama/saitama_midori-city/",
    :saitama_iwatsuki          => "saitama/saitama_iwatsuki-city/",
    :kawagoe                   => "saitama/kawagoe-city/",
    :kumagaya                  => "saitama/kumagaya-city/",
    :kawaguchi                 => "saitama/kawaguchi-city/",
    :gyoda                     => "saitama/gyoda-city/",
    :chichibu                  => "saitama/chichibu-city/",
    :tokorozawa                => "saitama/tokorozawa-city/",
    :hanno                     => "saitama/hanno-city/",
    :kazo                      => "saitama/kazo-city/",
    :honjo                     => "saitama/honjo-city/",
    :higashimatsuyama          => "saitama/higashimatsuyama-city/",
    :kasukabe                  => "saitama/kasukabe-city/",
    :sayama                    => "saitama/sayama-city/",
    :hanyu                     => "saitama/hanyu-city/",
    :konosu                    => "saitama/konosu-city/",
    :fukaya                    => "saitama/fukaya-city/",
    :ageo                      => "saitama/ageo-city/",
    :soka                      => "saitama/soka-city/",
    :koshigaya                 => "saitama/koshigaya-city/",
    :warabi                    => "saitama/warabi-city/",
    :toda                      => "saitama/toda-city/",
    :iruma                     => "saitama/iruma-city/",
    :asaka                     => "saitama/asaka-city/",
    :shiki                     => "saitama/shiki-city/",
    :wako                      => "saitama/wako-city/",
    :niiza                     => "saitama/niiza-city/",
    :okegawa                   => "saitama/okegawa-city/",
    :kuki                      => "saitama/kuki-city/",
    :kitamoto                  => "saitama/kitamoto-city/",
    :yashio                    => "saitama/yashio-city/",
    :fujimi                    => "saitama/fujimi-city/",
    :misato                    => "saitama/misato-city/",
    :hasuda                    => "saitama/hasuda-city/",
    :sakado                    => "saitama/sakado-city/",
    :satte                     => "saitama/satte-city/",
    :tsurugashima              => "saitama/tsurugashima-city/",
    :hidaka                    => "saitama/hidaka-city/",
    :yoshikawa                 => "saitama/yoshikawa-city/",
    :fujimino                  => "saitama/fujimino-city/",
    :shiraoka                  => "saitama/shiraoka-city/",
    :kitaadachi_ina            => "saitama/kitaadachi_ina-city/",
    :iruma_miyoshi             => "saitama/iruma_miyoshi-city/",
    :iruma_moroyama            => "saitama/iruma_moroyama-city/",
    :iruma_ogose               => "saitama/iruma_ogose-city/",
    :hiki_namegawa             => "saitama/hiki_namegawa-city/",
    :hiki_ranzan               => "saitama/hiki_ranzan-city/",
    :hiki_ogawa                => "saitama/hiki_ogawa-city/",
    :hiki_kawajima             => "saitama/hiki_kawajima-city/",
    :hiki_yoshimi              => "saitama/hiki_yoshimi-city/",
    :hiki_hatoyama             => "saitama/hiki_hatoyama-city/",
    :hiki_tokigawa             => "saitama/hiki_tokigawa-city/",
    :chichibu_yokoze           => "saitama/chichibu_yokoze-city/",
    :chichibu_minano           => "saitama/chichibu_minano-city/",
    :chichibu_nagatoro         => "saitama/chichibu_nagatoro-city/",
    :chichibu_ogano            => "saitama/chichibu_ogano-city/",
    :chichibu_higashichichibu  => "saitama/chichibu_higashichichibu-city/",
    :kodama_misato             => "saitama/kodama_misato-city/",
    :kodama_kamikawa           => "saitama/kodama_kamikawa-city/",
    :kodama_kamisato           => "saitama/kodama_kamisato-city/",
    :osato_yorii               => "saitama/osato_yorii-city/",
    :minamisaitama_miyashiro   => "saitama/minamisaitama_miyashiro-city/",
    :kitakatsushika_sugito     => "saitama/kitakatsushika_sugito-city/",
    :kitakatsushika_matsubushi => "saitama/kitakatsushika_matsubushi-city/",

    #Chiba
    :chiba_chuo                => "chiba/chiba_chuo-city/",
    :chiba_hanamigawa          => "chiba/chiba_hanamigawa-city/",
    :chiba_inage               => "chiba/chiba_inage-city/",
    :chiba_wakaba              => "chiba/chiba_wakaba-city/",
    :chiba_midori              => "chiba/chiba_midori-city/",
    :chiba_mihama              => "chiba/chiba_mihama-city/",
    :choshi                    => "chiba/choshi-city/",
    :ichikawa                  => "chiba/ichikawa-city/",
    :funabashi                 => "chiba/funabashi-city/",
    :tateyama                  => "chiba/tateyama-city/",
    :kisarazu                  => "chiba/kisarazu-city/",
    :matsudo                   => "chiba/matsudo-city/",
    :noda                      => "chiba/noda-city/",
    :mobara                    => "chiba/mobara-city/",
    :narita                    => "chiba/narita-city/",
    :sakura                    => "chiba/sakura-city/",
    :togane                    => "chiba/togane-city/",
    :asahi                     => "chiba/asahi-city/",
    :narashino                 => "chiba/narashino-city/",
    :kashiwa                   => "chiba/kashiwa-city/",
    :katsura                   => "chiba/katsura-city/",
    :ichihara                  => "chiba/ichihara-city/",
    :nagareyama                => "chiba/nagareyama-city/",
    :yachiyo                   => "chiba/yachiyo-city/",
    :abiko                     => "chiba/abiko-city/",
    :kamogawa                  => "chiba/kamogawa-city/",
    :kamagaya                  => "chiba/kamagaya-city/",
    :kimitsu                   => "chiba/kimitsu-city/",
    :futtsu                    => "chiba/futtsu-city/",
    :urayasu                   => "chiba/urayasu-city/",
    :yotsukaido                => "chiba/yotsukaido-city/",
    :sodegaura                 => "chiba/sodegaura-city/",
    :yachimata                 => "chiba/yachimata-city/",
    :inzai                     => "chiba/inzai-city/",
    :shiroi                    => "chiba/shiroi-city/",
    :tomisato                  => "chiba/tomisato-city/",
    :minamiboso                => "chiba/minamiboso-city/",
    :sosa                      => "chiba/sosa-city/",
    :katori                    => "chiba/katori-city/",
    :sammu                     => "chiba/sammu-city/",
    :isumi                     => "chiba/isumi-city/",
    :oamishirasato             => "chiba/oamishirasato-city/",
    :imba_shisui               => "chiba/imba_shisui-city/",
    :imba_sakae                => "chiba/imba_sakae-city/",
    :katori_kozaki             => "chiba/katori_kozaki-city/",
    :katori_tako               => "chiba/katori_tako-city/",
    :katori_tonosho            => "chiba/katori_tonosho-city/",
    :sambu_kujukuri            => "chiba/sambu_kujukuri-city/",
    :sambu_shibayama           => "chiba/sambu_shibayama-city/",
    :sambu_yokoshibahikari     => "chiba/sambu_yokoshibahikari-city/",
    :chosei_ichinomiya         => "chiba/chosei_ichinomiya-city/",
    :chosei_mutsuzawa          => "chiba/chosei_mutsuzawa-city/",
    :chosei_chosei             => "chiba/chosei_chosei-city/",
    :chosei_shirako            => "chiba/chosei_shirako-city/",
    :chosei_nagara             => "chiba/chosei_nagara-city/",
    :chosei_chonan             => "chiba/chosei_chonan-city/",
    :isumi_otaki               => "chiba/isumi_otaki-city/",
    :isumi_onjuku              => "chiba/isumi_onjuku-city/",
    :awa_kyonan                => "chiba/awa_kyonan-city/",
  }
    
  public
  def initialize(opts={})
    opts[:depth_limit] = 0 unless opts.has_key?(:depth_limit)
    opts[:delay] = 1 unless opts.has_key?(:delay)
    @opts = opts
  end
  def get_prop_urls_from_city(city)
    prop_urls = []
    if @@city2url.has_key?(city)
      prop_urls_list_pages = get_prop_urls_list_pages(city)
      prop_urls_list_pages.each {|list_page|
        prop_urls.concat(get_prop_urls_from_list_page(list_page))
      }
      prop_urls.sort!
      prop_urls.uniq!
    end
    prop_urls
  end
private
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
