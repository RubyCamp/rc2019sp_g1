require 'dxruby'
require 'chipmunk'

require_relative 'scene'
require_relative 'scene/opening/director'
require_relative 'scene/result/director'
require_relative 'scene/game/director'
require_relative 'scene/option/director'


Window.width = 500
Window.height = 650

Scene.add(Opening::Director.new, :opening)
Scene.add(Game::Director.new, :game)
Scene.add(Result::Director.new, :result)
Scene.add(Option::Director.new, :option)
Scene.move_to :opening

Window.loop do
    break if Input.key_push?(K_ESCAPE)
    Scene.play

end