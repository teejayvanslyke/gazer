require File.dirname(__FILE__) + '/spec_helper.rb'

def push(element)
  $queue << element
end

describe "advising around methods" do

  # == Setup

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

  class MockAspect < Gazer::Aspect::Base

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

  before :all do
    MockAspect.apply!
  end

  before :each do
    $queue = []
    @banana = Banana.new
    $queue = []
  end

  # ====
  
  it "executes the operations in the correct order for the instance advice" do
    @banana.peel!
    $queue.should == %w(Y U M)
  end

  it "executes the operations in the correct order for the class advice" do
    Banana.new
    $queue.should == %w(D I E)
  end

end
