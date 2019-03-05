class CP::Space
  STATIC_BODY = CP::Body.new_static
  STATIC_BODY.p = CP::Vec2.new(0, 0)

  def add(s)
    self.add_body(s.body) if s.body
    self.add_shape(s.shape)
  end

  def remove(s)
    self.remove_body(s.body) if s.body
    self.remove_shape(s.shape)
  end
end

class CPBase
  def self.walls
    walls = []
    walls << CPStaticBox.new(0, 768, 1024, 790)
    walls << CPStaticBox.new(-20, 0, 0, 768)
    walls << CPStaticBox.new(0, -20, 1024, 0)
    walls << CPStaticBox.new(1024, 0, 1044, 768)
    walls
  end

  def apply_force(x, y)
    body.apply_impulse(CP::Vec2.new(x, y), CP::Vec2.new(0, 0))
  end

  def set_eu(e, u)
    shape.e = e
    shape.u = u
  end
end