
#神は光あれと言った　すると光があった
class Light 
end

#神は光を昼と名づけ、やみを夜と名づけられた。夕となり、また朝となった。第一日である。
noon = Light.new
night = nil


#神はまた言われた、「水の間におおぞらがあって、水と水とを分けよ」。
class Water 
end

class Air
end

# 2-dim array world
sea = 10.times.map { Water.new }
sky = 10.times.map { Air.new }
cloud = 10.times.map { rand < 0.5 ? Air.new : Water.new }

world = [cloud, sky, sea]

pp world

#神はまた言われた、「天の下の水は一つ所に集まり、かわいた地が現れよ」
#神はそのかわいた地を陸と名づけ、水の集まった所を海と名づけられた。
class Soil
end

world[2] = 10.times.map { rand < 0.5 ? sea.choice : Soil.new }

