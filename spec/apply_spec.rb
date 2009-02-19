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

end
