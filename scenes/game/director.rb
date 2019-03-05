module Game
  class Director
    def initialize
      @font = Font.new(24)
      @space = CP::Space.new
      @space.gravity = CP::Vec2.new(0, 150)
      @current_stock = []
      @current_stock << CPCircle.new(21, 727, 20, 1, C_BLUE)
      @current_stock << CPBox.new(21, 727, 40, 40, 1, C_GREEN)
      @current_stock << CPCircle.new(21, 727, 20, 1, C_RED)
      @current = @current_stock.shift
      @walls = CPBase.walls
      @walls << CPStaticBox.new(200, 600, 800, 620)
      @walls << CPStaticBox.new(650, 200, 1000, 220)
      @space.add(@current)
      @walls.each do |wall|
        @space.add(wall)
      end
      @score = 0
      @power_bar_width = 10
      @power_v_size = 1
      @power_h_size = 1
      @power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
      @power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)
      @objects = [@current] + @walls
      @goals = []
      @goals << GoalCircle.new(300, 550, 20)
      @goals << GoalBox.new(700, 160, 40)
      @tanuki = Tanuki.new
    end

    def play
      @goals.each(&:draw)
      @objects.each(&:draw)
      shoot_tanuki
      @tanuki.move
      @tanuki.draw
      Window.draw(@current.body.p.x, @current.body.p.y - @power_v_size, @power_v) if @power_v_size > 1
      Window.draw(@current.body.p.x, @current.body.p.y, @power_h) if @power_h_size > 1
      apply_up_power if Input.key_push?(K_UP)
      apply_down_power if Input.key_push?(K_DOWN)
      apply_right_power if Input.key_push?(K_RIGHT)
      apply_left_power if Input.key_push?(K_LEFT)
      shoot if Input.key_push?(K_SPACE)
      @goals.each do |goal|
        case goal.judgement(@current)
        when 1
          @score += 1
          goal.begin_thumbup
          current_transition
        when -1
          @score -= 1 unless goal.bombing
          goal.begin_bomb
        end
      end
      Window.draw_font(900, 10, "SCORE: #{@score}", @font)
      @space.step(1 / 60.0)
      scene_transition
    end

    private

    def shoot_tanuki
      if rand(100) >= 99
        shoot_tanuki_bomb
      end
    end

    def shoot_tanuki_bomb
      bomb = CPCircle.new(@tanuki.x + @tanuki.img.width / 2, @tanuki.img.height, 10, 2, C_WHITE)
      bomb.body.apply_impulse(CP::Vec2.new(rand(200), rand(100) - 50), CP::Vec2.new(0, 0))
      @space.add(bomb)
      @objects << bomb
    end

    def current_transition
      @space.remove(@current)
      @objects.delete(@current)
      @current = nil
      if @current_stock.size >= 1
        @current = @current_stock.shift
        @space.add(@current)
        @objects << @current
      end
    end

    def apply_up_power
      @power_v_size += 10
      @power_v_size = Window.height if @power_v_size >= Window.height
      @power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
    end

    def apply_down_power
      @power_v_size -= 10
      @power_v_size = 1 if @power_v_size <= 1
      @power_v = Image.new(@power_bar_width, @power_v_size, C_GREEN)
    end

    def apply_right_power
      @power_h_size += 10
      @power_h_size = Window.width if @power_h_size >= Window.width
      @power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)
    end

    def apply_left_power
      @power_h_size -= 10
      @power_h_size = 1 if @power_h_size <= 1
      @power_h = Image.new(@power_h_size, @power_bar_width, C_GREEN)
    end

    def shoot
      @current.apply_force(@power_h_size * 5, -@power_v_size * 5)
      @power_h_size = 1
      @power_v_size = 1
    end

    def scene_transition
      Scene.move_to(:ending) unless @current
    end
  end
end
