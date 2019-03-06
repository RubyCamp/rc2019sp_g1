class Scene
  @@scenes = {}   # scenesにはハッシュを入れる  クラス変数

  @@current = nil

  def self.add(director, title)
    @@scenes[title.to_sym] = director   #titleをハッシュに変換したscenes要素にオブジェクトを設定
  end

  def self.move_to(title)
    @@current = title.to_sym
  end

  def self.play
    @@scenes[@@current].play
  end
end