# -*- coding: utf-8 -*-


module RegionControllerModule
  @@pref_info = {
    :tokyo => [:chiyoda, :chuo, :minato, :shinjuku, :bunkyo, :taito, :sumida, :koto, :shinagawa, :meguro, :ota, :setagaya, :shibuya, :nakano, :suginami, :toshima, :kita, :arakawa, :itabashi, :nerima, :adachi, :katsushika, :edogawa, :hachioji, :tachikawa, :musashino, :mitaka, :ome, :fuchu, :akishima, :chofu, :machida, :koganei, :kodaira, :hino, :higashimurayama, :kokubunji, :kunitachi, :fussa, :komae, :higashiyamato, :kiyose, :higashikurume, :musashimurayama, :tama, :inagi, :hamura, :akiruno, :nishitokyo, :nishitama_mizuho, :nishitama_hinode, :nishitama_hinohara, :nishitama_okutama, :tokyo13360, :oshima, :tokyo13362, :niijima, :kozushima, :tokyo13380, :miyake, :mikurajima, :tokyo13400, :hachijo, :aogashima, :tokyo13420, :ogasawara],
    :kanagawa => [:yokohama_tsurumi, :yokohama_kanagawa, :yokohama_nishi, :yokohama_naka, :yokohama_minami, :yokohama_hodogaya, :yokohama_isogo, :yokohama_kanazawa, :yokohama_kohoku, :yokohama_totsuka, :yokohama_konan, :yokohama_asahi, :yokohama_midori, :yokohama_seya, :yokohama_sakae, :yokohama_izumi, :yokohama_aoba, :yokohama_tsuzuki, :kawasaki_kawasaki, :kawasaki_saiwai, :kawasaki_nakahara, :kawasaki_takatsu, :kawasaki_tama, :kawasaki_miyamae, :kawasaki_asao, :sagamihara_midori, :sagamihara_chuo, :sagamihara_minami, :yokosuka, :hiratsuka, :kamakura, :fujisawa, :odawara, :chigasaki, :zushi, :miura, :hadano, :atsugi, :yamato, :isehara, :ebina, :zama, :minamiashigara, :ayase, :miura_hayama, :koza_samukawa, :naka_oiso, :naka_ninomiya, :ashigarakami_nakai, :ashigarakami_oi, :ashigarakami_matsuda, :ashigarakami_yamakita, :ashigarakami_kaisei, :ashigarashimo_hakone, :ashigarashimo_manazuru, :ashigarashimo_yugawara, :aiko_aikawa, :aiko_kiyokawa],
    :saitama => [:saitama_nishi, :saitama_kita, :saitama_omiya, :saitama_minuma, :saitama_chuo, :saitama_sakura, :saitama_urawa, :saitama_minami, :saitama_midori, :saitama_iwatsuki, :kawagoe, :kumagaya, :kawaguchi, :gyoda, :chichibu, :tokorozawa, :hanno, :kazo, :honjo, :higashimatsuyama, :kasukabe, :sayama, :hanyu, :konosu, :fukaya, :ageo, :soka, :koshigaya, :warabi, :toda, :iruma, :asaka, :shiki, :wako, :niiza, :okegawa, :kuki, :kitamoto, :yashio, :fujimi, :misato, :hasuda, :sakado, :satte, :tsurugashima, :hidaka, :yoshikawa, :fujimino, :shiraoka, :kitaadachi_ina, :iruma_miyoshi, :iruma_moroyama, :iruma_ogose, :hiki_namegawa, :hiki_ranzan, :hiki_ogawa, :hiki_kawajima, :hiki_yoshimi, :hiki_hatoyama, :hiki_tokigawa, :chichibu_yokoze, :chichibu_minano, :chichibu_nagatoro, :chichibu_ogano, :chichibu_higashichichibu, :kodama_misato, :kodama_kamikawa, :kodama_kamisato, :osato_yorii, :minamisaitama_miyashiro, :kitakatsushika_sugito, :kitakatsushika_matsubushi],
    :chiba => [:chiba_chuo, :chiba_hanamigawa, :chiba_inage, :chiba_wakaba, :chiba_midori, :chiba_mihama, :choshi, :ichikawa, :funabashi, :tateyama, :kisarazu, :matsudo, :noda, :mobara, :narita, :sakura, :togane, :asahi, :narashino, :kashiwa, :katsura, :ichihara, :nagareyama, :yachiyo, :abiko, :kamogawa, :kamagaya, :kimitsu, :futtsu, :urayasu, :yotsukaido, :sodegaura, :yachimata, :inzai, :shiroi, :tomisato, :minamiboso, :sosa, :katori, :sammu, :isumi, :oamishirasato, :imba_shisui, :imba_sakae, :katori_kozaki, :katori_tako, :katori_tonosho, :sambu_kujukuri, :sambu_shibayama, :sambu_yokoshibahikari, :chosei_ichinomiya, :chosei_mutsuzawa, :chosei_chosei, :chosei_shirako, :chosei_nagara, :chosei_chonan, :isumi_otaki, :isumi_onjuku, :awa_kyonan],
  }
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
  public
  def get_city_list(region)
    city_list = []
    city_list.concat(get_cities_from_prefecture(region)) if prefecture?(region)
    city_list.push(region) if city?(region)
    city_list
  end  
end
