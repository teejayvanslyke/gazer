require File.dirname(__FILE__) + '/spec_helper.rb'

def push(element)
  $queue << element
end

describe "advising around methods" do

  # == Setup

  before :each do
    $queue = []
  end

  class Banana
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

  end

  before :each do
    @banana = Banana.new
    MockAspect.apply!
  end

  # ====
  
  it "executes the operations in the correct order" do
    @banana.peel!
    $queue.should == %w(Y U M)
  end

end
