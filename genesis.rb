
# 神は光あれと言った　すると光があった
class Light end

# 神は光を昼と名づけ、やみを夜と名づけられた。夕となり、また朝となった。第一日である。
# noon = Light.new
# night = nil

# 神はまた言われた、「水の間におおぞらがあって、水と水とを分けよ」。
class Water end
class Air end

class Cloud
  def initialize
    component = [ 7.times.map { rand < 0.5 ? Air.new : Water.new } ]
  end
end

# 3-dim array world
BOXEL_SIZE = 10
def make_field
  BOXEL_SIZE.times.map { BOXEL_SIZE.times.map { yield } }
end

sea = make_field { Water.new }
sky = make_field { Air.new }
# cloud = make_field { rand < 0.5 ? Air.new : Water.new }
cloud = make_field { Water.new }

world = [cloud, sky, sea]

pp world
exit

# 神はまた言われた、「天の下の水は一つ所に集まり、かわいた地が現れよ」
# 神はそのかわいた地を陸と名づけ、水の集まった所を海と名づけられた。
class Soil end

world[2] = 10.times.map { rand < 0.5 ? sea.sample : Soil.new }

# 神はまた言われた、
# 「地は青草と、種をもつ草と、
# 種類にしたがって種のある実を結ぶ果樹とを地の上にはえさせよ」
class GrassSeed end

class Grass
  seeds = []
  def make_seed
    seeds << GrassSeed.new
  end
end

class Seed end

class Fruit 
  seeds = 10.times.map { Seed.new }
end

class Tree
  fruits = []
  def make_fruits
    fruits << Fruit.new
  end
end
