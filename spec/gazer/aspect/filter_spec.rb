require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Gazer::Aspect::Filter do

  class MockType1; end
  class MockType2; end

  describe "when using one type" do

    it "can advise before instance methods" do
      MockType1.should_receive(:advise_instances_before).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).
        advise_instances_before(:method) {}
    end

    it "can advise after instance methods" do
      MockType1.should_receive(:advise_instances_after).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).
        advise_instances_after(:method) {}
    end

    it "can advise around instance methods" do
      MockType1.should_receive(:advise_instances_around).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).advise_instances_around(:method) {}
    end

    it "can advise before class methods" do
      MockType1.should_receive(:advise_before).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).
        advise_before(:method) {}
    end

    it "can advise after class methods" do
      MockType1.should_receive(:advise_after).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).
        advise_after(:method) {}
    end

    it "can advise around class methods" do
      MockType1.should_receive(:advise_around).
        with(:method)
      Gazer::Aspect::Filter.new(MockType1).advise_around(:method) {}
    end
  end

  describe "when using an array of types" do
    before :each do 
      @expr = [ MockType1, MockType2 ]
    end

    it "can advise before instance methods" do
      MockType1.should_receive(:advise_instances_before).
        with(:method)
      MockType2.should_receive(:advise_instances_before).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_instances_before(:method) {}
    end

    it "can advise after instance methods" do
      MockType1.should_receive(:advise_instances_after).
        with(:method)
      MockType2.should_receive(:advise_instances_after).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_instances_after(:method) {}
    end

    it "can advise around instance methods" do
      MockType1.should_receive(:advise_instances_around).
        with(:method)
      MockType2.should_receive(:advise_instances_around).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).advise_instances_around(:method) {}
    end

    it "can advise before class methods" do
      MockType1.should_receive(:advise_before).
        with(:method)
      MockType2.should_receive(:advise_before).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_before(:method) {}
    end

    it "can advise after class methods" do
      MockType1.should_receive(:advise_after).
        with(:method)
      MockType2.should_receive(:advise_after).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_after(:method) {}
    end

    it "can advise around class methods" do
      MockType1.should_receive(:advise_around).
        with(:method)
      MockType2.should_receive(:advise_around).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).advise_around(:method) {}
    end
  end

  describe "when using a regex filter" do

    before :each do 
      @expr = /^MockType[0-9]$/
    end

    it "doesn't advise the Class class" do
      Class.should_not_receive(:advise_before)
      Gazer::Aspect::Filter.new(@expr).advise_before(:method) {}
    end

    it "can advise before instance methods" do
      MockType1.should_receive(:advise_instances_before).
        with(:method)
      MockType2.should_receive(:advise_instances_before).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_instances_before(:method) {}
    end

    it "can advise after instance methods" do
      MockType1.should_receive(:advise_instances_after).
        with(:method)
      MockType2.should_receive(:advise_instances_after).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_instances_after(:method) {}
    end

    it "can advise around instance methods" do
      MockType1.should_receive(:advise_instances_around).
        with(:method)
      MockType2.should_receive(:advise_instances_around).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).advise_instances_around(:method) {}
    end

    it "can advise before class methods" do
      MockType1.should_receive(:advise_before).
        with(:method)
      MockType2.should_receive(:advise_before).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_before(:method) {}
    end

    it "can advise after class methods" do
      MockType1.should_receive(:advise_after).
        with(:method)
      MockType2.should_receive(:advise_after).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).
        advise_after(:method) {}
    end

    it "can advise around class methods" do
      MockType1.should_receive(:advise_around).
        with(:method)
      MockType2.should_receive(:advise_around).
        with(:method)
      Gazer::Aspect::Filter.new(@expr).advise_around(:method) {}
    end

    describe "and it is a pure wildcard" do

      before :each do 
        @expr = /^.*$/
      end

      it "doesn't advise the Class class" do
        Class.should_not_receive(:advise_before)
        Gazer::Aspect::Filter.new(@expr).advise_before(:method) {}
      end

    end

  end

end
