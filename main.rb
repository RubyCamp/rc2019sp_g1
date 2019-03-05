require 'dxruby'
require 'chipmunk'

require_relative 'scene'
require_relative 'scenes/opening/director'
require_relative 'scenes/game/director'
require_relative 'scenes/ending/director'

require_relative 'lib/cp'
require_relative 'lib/cp_circle'
require_relative 'lib/cp_box'
require_relative 'lib/cp_static_box'
require_relative 'lib/goal'
require_relative 'lib/goal_circle'
require_relative 'lib/goal_box'
require_relative 'lib/tanuki'

Window.width = 500
Window.height = 650

Scene.add(Opening::Director.new, :opening)
Scene.add(Game::Director.new, :game)
Scene.add(Ending::Director.new, :ending)
Scene.move_to :opening

Window.loop do
  break if Input.key_push?(K_ESCAPE)
  Scene.play
end
