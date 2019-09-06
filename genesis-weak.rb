
require 'curses'

HEIGHT = 30
WIDTH = 50
ENERGY = 100
LIFESPAN = 200
N_LIFE = 40

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
    '*'
  end
end

class Life
  attr_accessor :prop, :pos, :lifespan, :energy
  def initialize
    @prop = 4.times.map { rand < 0.5 ? 0 : 1 }
    @pos = { y: rand(HEIGHT), x: rand(WIDTH) }
    @energy= rand(ENERGY)
    @lifespan= rand(LIFESPAN)
  end

  def icon
    @prop.join().to_i(2).to_s(16)
  end

  def can_move?(world, pos, direction, dx)
    return true if @prop[3] == 1
    dist = pos[direction] + dx
    if direction == :x
      return false if (dist >= WIDTH || dist < 0)
      return false if world[pos[:y]][dist].class == Water
    else
      return false if (dist >= HEIGHT || dist < 0)
      return false if world[dist][pos[:x]].class == Water
    end
    true
  end

  def eat(life)
    @energy += life.energy
    life.energy = 0
    life.lifespan = 0
  end

  def replicate(life, lifes, world)
    nlife = Life.new
    nlife.prop = @prop
    nlife.pos = Marshal.load(Marshal.dump(@pos))
    nlife.move(world, force: true)

    duplicate_location = false
    lifes.each do |olife|
      duplicate_location = (olife.pos[:x] == nlife.pos[:x] && olife.pos[:y] == nlife.pos[:y])
      break if duplicate_location
    end
    lifes << nlife unless duplicate_location
  end

  def dead?
    return (@lifespan <= 0 || @energy <= 0)
  end

  def event(lifes, world)
    @lifespan -= 1
    @energy -= 0.2

    if @prop[2] == 1 # kougousei
      @energy += 1
    end

    if @prop[1] == 1 # unisex
      self.replicate(self, lifes, world) if @energy >= 110
    end

    lifes.each do |life| 
      next if life == self
      next if life.dead?

      if life.pos[:y] == @pos[:y] && life.pos[:x] == @pos[:x]
        if life.icon == self.icon
          if @prop[1] == 0
            self.replicate(life, lifes, world)
          end
        else
          self.eat(life) if @prop[2] == 0 # pradator
        end
        break
      end
    end
  end

  def move(world, force: false)
    dx = rand(2)
    if @prop[0] == 1 || force
      if (rand > 0.5)
        direction = :y
      else
        direction = :x
      end
      if (rand > 0.5)
        dx *= -1
      end
      @pos[direction] += dx if can_move?(world, pos, direction, dx)
      @energy -= 0.2
      if @prop[3] == 1
        @energy -= 0.2
      end
    end
  end
end

world = HEIGHT.times.map { 
  # WIDTH.times.map { rand > 0.5 ? Water.new : Ground.new }
  WIDTH.times.map { Ground.new }
}

lifes = N_LIFE.times.map { Life.new }
# lifes.each {|i| pp i}

world.each do |line|
  line.sort! do |a, b|
    (a.class == b.class ? 1 : 0)
  end
end

# pp world
# exit

Curses.init_screen
begin
  while true do
    world.each.with_index do |line, y|
      line.each.with_index do |e, x|
        Curses.setpos(y, x)
        Curses.addstr(e.str)
        # Curses.refresh
      end
    end

    lifes.each do |life|
      Curses.setpos(life.pos[:y], life.pos[:x])
      Curses.addstr(life.icon)
      life.move(world)
      life.event(lifes, world)
      # Curses.refresh
    end

    lifes.delete_if {|life| life.dead? }
    Curses.refresh

    sleep 0.1
  end
ensure
  Curses.close_screen
end

