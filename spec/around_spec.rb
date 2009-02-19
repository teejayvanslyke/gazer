$dir = File.dirname(__FILE__)
require $dir + '/spec_helper.rb'
require $dir + '/fixtures/bananas'

describe "advising around methods" do

  before :all do
    BananaAspect.apply!
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

  after :all do
    Banana.unadvise_all
  end

end
