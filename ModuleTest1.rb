# coding: utf-8
module HeikinModule
  def heikin(x, y)
    kekka = (x + y) / 2
    return kekka
  end
end

class Test
  include HeikinModule

  def dispHeikin(x, y)
    kekka = heikin(x, y)
    print(x, "と", y, "の平均は", kekka, "です¥n")
  end
end

test = Test.new
test.dispHeikin(10, 8)
