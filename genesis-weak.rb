
require 'curses'

Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_BLUE)

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

height = 60
width = 200
world = height.times.map { 
  width.times.map { rand > 0.7 ? Water.new : Ground.new }
}

# pp world
# exit

world.each do |line|
  line.sort! do |a, b|
    (a.class == b.class ? 1 : 0)
  end
end

# pp world
# exit

Curses.init_screen
begin
  world.each.with_index do |line, y|
    line.each.with_index do |e, x|
      Curses.setpos(y, x)
      # Curses.addstr(e.str)
      Curses.attrset(Curses.color_pair(e.color))
      Curses.addstr(e.str)
      Curses.refresh
    end
  end
  Curses.getch
ensure
  Curses.close_screen
end

