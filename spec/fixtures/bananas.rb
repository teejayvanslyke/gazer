def push(element)
  $queue << element
end

class Banana
  class << self
    def plant!;     push('D'); end
    def cut_down!;  push('E'); end
  end
  def initialize; push('I'); end
  def peel!; push('U'); end
  def pick!; push('Y'); end
  def eat!;  push('M'); end
end

class BananaAspect < Gazer::Aspect::Base

  around instances_of(Banana) => :peel! do |point|
    point.object.pick!
    point.yield
    point.object.eat!
  end

  around Banana => :new do |point|
    Banana.plant!
    banana = point.yield
    Banana.cut_down!
    banana
  end

end

