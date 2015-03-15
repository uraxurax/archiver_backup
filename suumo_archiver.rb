# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'anemone'


class SuumoArchiver
  @@pref_info = {
    :tokyo => [:chiyoda, :chuo, :minato, :shinjuku, :bunkyo, :shibuya, :taito, :sumida, :koto, :arakawa, :adachi, :katsushika, :edogawa, :shinagawa, :meguro, :ota, :setagaya, :nakano, :suginami, :nerima, :toshima, :kita, :itabashi, :hachioji, :tachikawa, :musashino, :mitaka, :ome, :fuchu, :akishima, :chofu, :machida, :koganei, :kodaira, :hino, :higashimurayama, :kokubunji, :kunitachi, :fussa, :komae, :higashiyamato, :kiyose, :higashikurume, :musashimurayama, :tama, :inagi, :hamura, :akiruno, :nishitokyo, :nishitamagun, :oshimashicho, :oshima, :toshimamura, :niijima, :kozushima, :miyakeshicho, :miyakejimamiyake, :mikurajima, :hachijoshicho, :hachijojimahachijo, :aogashima, :ogasawarashicho, :ogasawara],
    :kanagawa => [:yokohamashitsurumi, :yokohamashikanagawa, :yokohamashinishi, :yokohamashinaka, :yokohamashiminami, :yokohamashihodogaya, :yokohamashiisogo, :yokohamashikanazawa, :yokohamashikohoku, :yokohamashitotsuka, :yokohamashikonan, :yokohamashiasahi, :yokohamashimidori, :yokohamashiseya, :yokohamashisakae, :yokohamashiizumi, :yokohamashiaoba, :yokohamashitsuzuki, :kawasakishikawasaki, :kawasakishisaiwai, :kawasakishinakahara, :kawasakishitakatsu, :kawasakishitama, :kawasakishimiyamae, :kawasakishiasao, :sagamiharashimidori, :sagamiharashichuo, :sagamiharashiminami, :yokosuka, :hiratsuka, :kamakura, :fujisawa, :odawara, :chigasaki, :zushi, :miura, :hadano, :atsugi, :yamato, :isehara, :ebina, :zama, :minamiashigara, :ayase, :miuragun, :kozagun, :nakagun, :ashigarakamigun, :aikogun, :ashigarashimogun],
    :saitama => [:saitamashinishi, :saitamashikita, :saitamashiomiya, :saitamashiminuma, :saitamashichuo, :saitamashisakura, :saitamashiurawa, :saitamashiminami, :saitamashimidori, :saitamashiiwatsuki, :kawagoe, :kumagaya, :kawaguchi, :gyoda, :chichibu, :tokorozawa, :hanno, :kazo, :honjo, :higashimatsuyama, :kasukabe, :sayama, :hanyu, :konosu, :fukaya, :ageo, :soka, :koshigaya, :warabi, :toda, :iruma, :asaka, :shiki, :wako, :niiza, :okegawa, :kuki, :kitamoto, :yashio, :fujimi, :misato, :hasuda, :sakado, :satte, :tsurugashima, :hidaka, :yoshikawa, :fujimino, :shiraoka, :kitaadachigun, :irumagun, :hikigun, :chichibugun, :kodamagun, :osatogun, :minamisaitamagun, :kitakatsushikagun],
    :chiba => [:chibashichuo, :chibashihanamigawa, :chibashiinage, :chibashiwakaba, :chibashimidori, :chibashimihama, :choshi, :ichikawa, :funabashi, :tateyama, :kisarazu, :matsudo, :noda, :mobara, :narita, :sakura, :togane, :asahi, :narashino, :kashiwa, :katsuura, :ichihara, :nagareyama, :yachiyo, :abiko, :kamogawa, :kamagaya, :kimitsu, :futtsu, :urayasu, :yotsukaido, :sodegaura, :yachimata, :inzai, :shiroi, :tomisato, :minamiboso, :sosa, :katori, :sammu, :isumi, :oamishirasato, :imbagun, :katorigun, :sambugun, :choseigun, :isumigun, :awagun],
  }
  @@city2url = {
    # Tokyo
    :chiyoda             => "tokyo/sc_chiyoda",
    :chuo                => "tokyo/sc_chuo",
    :minato              => "tokyo/sc_minato",
    :shinjuku            => "tokyo/sc_shinjuku",
    :bunkyo              => "tokyo/sc_bunkyo",
    :shibuya             => "tokyo/sc_shibuya",
    :taito               => "tokyo/sc_taito",
    :sumida              => "tokyo/sc_sumida",
    :koto                => "tokyo/sc_koto",
    :arakawa             => "tokyo/sc_arakawa",
    :adachi              => "tokyo/sc_adachi",
    :katsushika          => "tokyo/sc_katsushika",
    :edogawa             => "tokyo/sc_edogawa",
    :shinagawa           => "tokyo/sc_shinagawa",
    :meguro              => "tokyo/sc_meguro",
    :ota                 => "tokyo/sc_ota",
    :setagaya            => "tokyo/sc_setagaya",
    :nakano              => "tokyo/sc_nakano",
    :suginami            => "tokyo/sc_suginami",
    :nerima              => "tokyo/sc_nerima",
    :toshima             => "tokyo/sc_toshima",
    :kita                => "tokyo/sc_kita",
    :itabashi            => "tokyo/sc_itabashi",
    :hachioji            => "tokyo/sc_hachioji",
    :tachikawa           => "tokyo/sc_tachikawa",
    :musashino           => "tokyo/sc_musashino",
    :mitaka              => "tokyo/sc_mitaka",
    :ome                 => "tokyo/sc_ome",
    :fuchu               => "tokyo/sc_fuchu",
    :akishima            => "tokyo/sc_akishima",
    :chofu               => "tokyo/sc_chofu",
    :machida             => "tokyo/sc_machida",
    :koganei             => "tokyo/sc_koganei",
    :kodaira             => "tokyo/sc_kodaira",
    :hino                => "tokyo/sc_hino",
    :higashimurayama     => "tokyo/sc_higashimurayama",
    :kokubunji           => "tokyo/sc_kokubunji",
    :kunitachi           => "tokyo/sc_kunitachi",
    :fussa               => "tokyo/sc_fussa",
    :komae               => "tokyo/sc_komae",
    :higashiyamato       => "tokyo/sc_higashiyamato",
    :kiyose              => "tokyo/sc_kiyose",
    :higashikurume       => "tokyo/sc_higashikurume",
    :musashimurayama     => "tokyo/sc_musashimurayama",
    :tama                => "tokyo/sc_tama",
    :inagi               => "tokyo/sc_inagi",
    :hamura              => "tokyo/sc_hamura",
    :akiruno             => "tokyo/sc_akiruno",
    :nishitokyo          => "tokyo/sc_nishitokyo",
    :nishitamagun        => "tokyo/sc_nishitamagun",
    :oshimashicho        => "tokyo/sc_oshimashicho",
    :oshima              => "tokyo/sc_oshima",
    :toshimamura         => "tokyo/sc_toshimamura",
    :niijima             => "tokyo/sc_niijima/",
    :kozushima           => "tokyo/sc_kozushima",
    :miyakeshicho        => "tokyo/sc_miyakeshicho",
    :miyakejimamiyake    => "tokyo/sc_miyakejimamiyake",
    :mikurajima          => "tokyo/sc_mikurajima",
    :hachijoshicho       => "tokyo/sc_hachijoshicho",
    :hachijojimahachijo  => "tokyo/sc_hachijojimahachijo",
    :aogashima           => "tokyo/sc_aogashima",
    :ogasawarashicho     => "tokyo/sc_ogasawarashicho",
    :ogasawara           => "tokyo/sc_ogasawara",
    #Kanagawa
    :yokohamashitsurumi  => "kanagawa/sc_yokohamashitsurumi",
    :yokohamashikanagawa => "kanagawa/sc_yokohamashikanagawa",
    :yokohamashinishi    => "kanagawa/sc_yokohamashinishi",
    :yokohamashinaka     => "kanagawa/sc_yokohamashinaka",
    :yokohamashiminami   => "kanagawa/sc_yokohamashiminami",
    :yokohamashihodogaya => "kanagawa/sc_yokohamashihodogaya",
    :yokohamashiisogo    => "kanagawa/sc_yokohamashiisogo",
    :yokohamashikanazawa => "kanagawa/sc_yokohamashikanazawa",
    :yokohamashikohoku   => "kanagawa/sc_yokohamashikohoku",
    :yokohamashitotsuka  => "kanagawa/sc_yokohamashitotsuka",
    :yokohamashikonan    => "kanagawa/sc_yokohamashikonan",
    :yokohamashiasahi    => "kanagawa/sc_yokohamashiasahi",
    :yokohamashimidori   => "kanagawa/sc_yokohamashimidori",
    :yokohamashiseya     => "kanagawa/sc_yokohamashiseya",
    :yokohamashisakae    => "kanagawa/sc_yokohamashisakae",
    :yokohamashiizumi    => "kanagawa/sc_yokohamashiizumi",
    :yokohamashiaoba     => "kanagawa/sc_yokohamashiaoba",
    :yokohamashitsuzuki  => "kanagawa/sc_yokohamashitsuzuki",
    :kawasakishikawasaki => "kanagawa/sc_kawasakishikawasaki",
    :kawasakishisaiwai   => "kanagawa/sc_kawasakishisaiwai",
    :kawasakishinakahara => "kanagawa/sc_kawasakishinakahara",
    :kawasakishitakatsu  => "kanagawa/sc_kawasakishitakatsu",
    :kawasakishitama     => "kanagawa/sc_kawasakishitama",
    :kawasakishimiyamae  => "kanagawa/sc_kawasakishimiyamae",
    :kawasakishiasao     => "kanagawa/sc_kawasakishiasao",
    :sagamiharashimidori => "kanagawa/sc_sagamiharashimidori",
    :sagamiharashichuo   => "kanagawa/sc_sagamiharashichuo",
    :sagamiharashiminami => "kanagawa/sc_sagamiharashiminami",
    :yokosuka            => "kanagawa/sc_yokosuka",
    :hiratsuka           => "kanagawa/sc_hiratsuka",
    :kamakura            => "kanagawa/sc_kamakura",
    :fujisawa            => "kanagawa/sc_fujisawa",
    :odawara             => "kanagawa/sc_odawara",
    :chigasaki           => "kanagawa/sc_chigasaki",
    :zushi               => "kanagawa/sc_zushi",
    :miura               => "kanagawa/sc_miura",
    :hadano              => "kanagawa/sc_hadano",
    :atsugi              => "kanagawa/sc_atsugi",
    :yamato              => "kanagawa/sc_yamato",
    :isehara             => "kanagawa/sc_isehara",
    :ebina               => "kanagawa/sc_ebina",
    :zama                => "kanagawa/sc_zama",
    :minamiashigara      => "kanagawa/sc_minamiashigara",
    :ayase               => "kanagawa/sc_ayase",
    :miuragun            => "kanagawa/sc_miuragun",
    :kozagun             => "kanagawa/sc_kozagun",
    :nakagun             => "kanagawa/sc_nakagun",
    :ashigarakamigun     => "kanagawa/sc_ashigarakamigun",
    :aikogun             => "kanagawa/sc_aikogun",
    :ashigarashimogun    => "kanagawa/sc_ashigarashimogun",
    #Saitama
    :saitamashinishi     => "saitama/sc_saitamashinishi",
    :saitamashikita      => "saitama/sc_saitamashikita",
    :saitamashiomiya     => "saitama/sc_saitamashiomiya",
    :saitamashiminuma    => "saitama/sc_saitamashiminuma",
    :saitamashichuo      => "saitama/sc_saitamashichuo",
    :saitamashisakura    => "saitama/sc_saitamashisakura",
    :saitamashiurawa     => "saitama/sc_saitamashiurawa",
    :saitamashiminami    => "saitama/sc_saitamashiminami",
    :saitamashimidori    => "saitama/sc_saitamashimidori",
    :saitamashiiwatsuki  => "saitama/sc_saitamashiiwatsuki",
    :kawagoe             => "saitama/sc_kawagoe",
    :kumagaya            => "saitama/sc_kumagaya",
    :kawaguchi           => "saitama/sc_kawaguchi",
    :gyoda               => "saitama/sc_gyoda",
    :chichibu            => "saitama/sc_chichibu",
    :tokorozawa          => "saitama/sc_tokorozawa",
    :hanno               => "saitama/sc_hanno",
    :kazo                => "saitama/sc_kazo",
    :honjo               => "saitama/sc_honjo",
    :higashimatsuyama    => "saitama/sc_higashimatsuyama",
    :kasukabe            => "saitama/sc_kasukabe",
    :sayama              => "saitama/sc_sayama",
    :hanyu               => "saitama/sc_hanyu",
    :konosu              => "saitama/sc_konosu",
    :fukaya              => "saitama/sc_fukaya",
    :ageo                => "saitama/sc_ageo",
    :soka                => "saitama/sc_soka",
    :koshigaya           => "saitama/sc_koshigaya",
    :warabi              => "saitama/sc_warabi",
    :toda                => "saitama/sc_toda",
    :iruma               => "saitama/sc_iruma",
    :asaka               => "saitama/sc_asaka",
    :shiki               => "saitama/sc_shiki",
    :wako                => "saitama/sc_wako",
    :niiza               => "saitama/sc_niiza",
    :okegawa             => "saitama/sc_okegawa",
    :kuki                => "saitama/sc_kuki",
    :kitamoto            => "saitama/sc_kitamoto",
    :yashio              => "saitama/sc_yashio",
    :fujimi              => "saitama/sc_fujimi",
    :misato              => "saitama/sc_misato",
    :hasuda              => "saitama/sc_hasuda",
    :sakado              => "saitama/sc_sakado",
    :satte               => "saitama/sc_satte",
    :tsurugashima        => "saitama/sc_tsurugashima",
    :hidaka              => "saitama/sc_hidaka",
    :yoshikawa           => "saitama/sc_yoshikawa",
    :fujimino            => "saitama/sc_fujimino",
    :shiraoka            => "saitama/sc_shiraoka",
    :kitaadachigun       => "saitama/sc_kitaadachigun",
    :irumagun            => "saitama/sc_irumagun",
    :hikigun             => "saitama/sc_hikigun",
    :chichibugun         => "saitama/sc_chichibugun",
    :kodamagun           => "saitama/sc_kodamagun",
    :osatogun            => "saitama/sc_osatogun",
    :minamisaitamagun    => "saitama/sc_minamisaitamagun",
    :kitakatsushikagun   => "saitama/sc_kitakatsushikagun",
    #Chiba
    :chibashichuo        => "chiba/sc_chibashichuo",
    :chibashihanamigawa  => "chiba/sc_chibashihanamigawa",
    :chibashiinage       => "chiba/sc_chibashiinage",
    :chibashiwakaba      => "chiba/sc_chibashiwakaba",
    :chibashimidori      => "chiba/sc_chibashimidori",
    :chibashimihama      => "chiba/sc_chibashimihama",
    :choshi              => "chiba/sc_choshi",
    :ichikawa            => "chiba/sc_ichikawa",
    :funabashi           => "chiba/sc_funabashi",
    :tateyama            => "chiba/sc_tateyama",
    :kisarazu            => "chiba/sc_kisarazu",
    :matsudo             => "chiba/sc_matsudo",
    :noda                => "chiba/sc_noda",
    :mobara              => "chiba/sc_mobara",
    :narita              => "chiba/sc_narita",
    :sakura              => "chiba/sc_sakura",
    :togane              => "chiba/sc_togane",
    :asahi               => "chiba/sc_asahi",
    :narashino           => "chiba/sc_narashino",
    :kashiwa             => "chiba/sc_kashiwa",
    :katsuura            => "chiba/sc_katsuura",
    :ichihara            => "chiba/sc_ichihara",
    :nagareyama          => "chiba/sc_nagareyama",
    :yachiyo             => "chiba/sc_yachiyo",
    :abiko               => "chiba/sc_abiko",
    :kamogawa            => "chiba/sc_kamogawa",
    :kamagaya            => "chiba/sc_kamagaya",
    :kimitsu             => "chiba/sc_kimitsu",
    :futtsu              => "chiba/sc_futtsu",
    :urayasu             => "chiba/sc_urayasu",
    :yotsukaido          => "chiba/sc_yotsukaido",
    :sodegaura           => "chiba/sc_sodegaura",
    :yachimata           => "chiba/sc_yachimata",
    :inzai               => "chiba/sc_inzai",
    :shiroi              => "chiba/sc_shiroi",
    :tomisato            => "chiba/sc_tomisato",
    :minamiboso          => "chiba/sc_minamiboso",
    :sosa                => "chiba/sc_sosa",
    :katori              => "chiba/sc_katori",
    :sammu               => "chiba/sc_sammu",
    :isumi               => "chiba/sc_isumi",
    :oamishirasato       => "chiba/sc_oamishirasato",
    :imbagun             => "chiba/sc_imbagun",
    :katori              => "chiba/sc_katorigun",    
    :sambugun            => "chiba/sc_sambugun",
    :choseigun           => "chiba/sc_choseigun",
    :isumigun            => "chiba/sc_isumigun",
    :awagun              => "chiba/sc_awagun",
  }
    
  public
  def initialize(opts={})
    opts[:depth_limit] = 0 unless opts.has_key?(:depth_limit)
    opts[:delay] = 1 unless opts.has_key?(:delay)
    @opts = opts
  end

  def get_city_list(region)
    city_list = []
    city_list.concat(get_cities_from_prefecture(region)) if prefecture?(region)
    city_list.push(region) if city?(region)
    city_list
  end  

  def get_prop_urls_from_city(city)
    prop_urls = []
    if @@city2url.has_key?(city)
      prop_urls_list_pages = get_prop_urls_list_pages(city)
      prop_urls_list_pages.each {|list_page|
        prop_urls.concat(get_prop_urls_from_list_page(city, list_page))
        prop_urls.uniq!
      }
      prop_urls.sort!
      prop_urls.uniq!
    end
    prop_urls
  end
  private
  def prefecture?(prefecture)
    @@pref_info.has_key?(prefecture)
  end

  def get_cities_from_prefecture(prefecture)
    @@pref_info[prefecture] rescue []
  end
  
  def city?(region)
    city = false
    @@pref_info.each {|key, value|
      city = true if value.include?(region)
    }
    city
  end
  
  def get_prop_urls_list_pages(city)
    list_pages = []
    base_url = get_base_url(city)
    doc = Nokogiri::HTML(open(base_url))
    prop_num = doc.xpath('//*[@id="js-sectionBody-main"]/div[1]/div[1]/text()').text.to_i
    
    num = 0
    while num*30 < prop_num do
      num += 1
      list_pages.push(base_url + 'pnz1' + num.to_s + '.html')
    end
    list_pages
  end

  def get_prop_urls_from_list_page(city, list_page)
    prop_urls = []
    base_url = get_base_url(city)

    Anemone.crawl(list_page, @opts) do |anemone|
      anemone.on_every_page do |page|
        links = page.links()
        links.each{|link|
          if /^#{base_url}nc_\d*?\/$/ =~ link.to_s
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
    'http://suumo.jp/tochi/' + @@city2url[city] + '/'
  end
end
