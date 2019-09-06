
require 'curses'

# HEIGHT = 60
# WIDTH = 200

HEIGHT = 20
WIDTH = 40
ENERGY = 100
N_LIFE = 10

class Ground 
  def color
   1
  end
  def str
    ' '
  end
end

class Water 
  def color
    2
  end
  def str
    '}'
  end
end

class Life
  attr_accessor :prop, :pos, :lifespan, :energy
  def initialize
    @prop = 4.times.map { rand < 0.5 ? 0 : 1 }
    @pos = { y: rand(HEIGHT), x: rand(WIDTH) }
    @energy= rand(ENERGY)
  end

  def icon
    @prop.join().to_i(2).to_s(16)
  end

  def can_move?(world, pos, direction, dx)
    return true if @prop[3] == 1
    dist = pos[direction] + dx
    if direction == :x
      return false if dist >= WIDTH || dist < 0
      if world[pos[:y]][pos[:x] + dx].class == Water
        return false
      end
    else
      return false if dist >= HEIGHT || dist < 0
      if world[pos[:y]+dx][pos[:x]].class == Water
        return false
      end
    end
    true
  end

  def eat(life)
    @energy += life.energy
    life.energy = 0
  end

  def replicate(life, lifes)
    nlife = Life.new
    nlife.prop = @prop
    nlife.pos = @pos.dup
    nlife.move(nil)
    lifes << nlife
  end

  def dead?
    return (@energy <= 0)
  end

  def event(lifes)
    @energy -= 1
    if @prop[1] == 1 # unisex
      self.replicate(self, lifes) if @energy >= 90
    else
      lifes.each do |life| 
        next if life == self
        next if life.dead?

        if life.pos[:y] == @pos[:y] && life.pos[:x] == @pos[:x]
          if life.icon == self.icon
            self.replicate(life, lifes)
          else
            self.eat(life) if @prop[2] == 0 # pradator
          end
        end
      end
    end

    if @prop[2] == 1 # kougousei
      @energy += 3
    end
  end

  def move(world)
    dx = rand(2)

    if world.nil?
      if (rand > 0.5)
        direction = :y
      else
        direction = :x
      end
      if (rand > 0.5)
        dx *= -1
      end
      @pos[direction] += dx
      return
    end

    if @prop[0] == 1
      if (rand > 0.5)
        direction = :y
      else
        direction = :x
      end
      if (rand > 0.5)
        dx *= -1
      end
      @pos[direction] += dx if can_move?(world, pos, direction, dx)
      @energy -= 1
      if @prop[3] == 1
        @energy -= 1
      end
    end
  end
end

world = HEIGHT.times.map { 
  WIDTH.times.map { rand > 0.7 ? Water.new : Ground.new }
}

lifes = N_LIFE.times.map { Life.new }
lifes.each {|i| pp i}

world.each do |line|
  line.sort! do |a, b|
    (a.class == b.class ? 1 : 0)
  end
end

# pp world
# exit

Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_BLUE)
Curses.init_screen
begin
  while true do
    world.each.with_index do |line, y|
      line.each.with_index do |e, x|
        Curses.setpos(y, x)
        Curses.attrset(Curses.color_pair(e.color))
        Curses.addstr(e.str)
        Curses.refresh
      end
    end

    lifes.each do |life|
      Curses.setpos(life.pos[:y], life.pos[:x])
      Curses.addstr(life.icon)
      Curses.refresh
      life.move(world)
      life.event(lifes)
    end

    lifes.delete_if {|life| life.dead? }

    sleep 1
  end
ensure
  Curses.close_screen
end

