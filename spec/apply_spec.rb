$dir = File.dirname(__FILE__)
require $dir + '/spec_helper.rb'
require $dir + '/fixtures/bananas'

describe "when applying aspects" do

  before { $queue = [] }

  it "doesn't apply an aspect twice if apply! is called twice" do
    BananaAspect.apply!
    BananaAspect.apply!
    Banana.new
    $queue.should == %w(D I E)
  end

  it "removes all associated advice if remove! is called" do
    pending
    BananaAspect.apply!
    BananaAspect.remove!
    Banana.new
    $queue.should == []
  end

  it "doesn't try to remove advice more than once" do
    pending
    lambda {
      BananaAspect.apply!
      BananaAspect.remove!
      BananaAspect.remove!
      Banana.new
      $queue.should == []
    }.should_not raise_error
  end

end
