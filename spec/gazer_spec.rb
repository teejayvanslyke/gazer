require File.dirname(__FILE__) + '/spec_helper.rb'


def message(text) end
describe Gazer do

  include Gazer

  class Dog

    def self.create
      new
    end

    def bark!
      "woof!"
    end

  end

  class Cat
    def hiss!
    end

    def run_away!
    end

    def self.get_scared
    end
  end

  describe "advising instance methods" do

    describe "before the method call" do

      it "executes the advice provided before the method is executed" do

        @cat = Cat.new

        Dog.advise_instances_before(:bark!) do |point|
          @cat.hiss!
        end

        @dog = Dog.new
        @cat.should_receive(:hiss!)
        @dog.bark! 

      end

    end

    describe "after the method call" do

      it "executes the advice provided after the method is executed" do

        @cat = Cat.new

        Dog.advise_instances_after(:bark!) do |point|
          @cat.run_away!
        end

        @dog = Dog.new
        @cat.should_receive(:run_away!)
        @dog.bark! 
      end

    end

  end

  describe "advising class methods" do

    describe "before the method call" do

      it "executes the advice provided before the method is executed" do

        Dog.unadvise_all
        Cat.unadvise_all

        Dog.advise_before(:create) do |point|
          Cat.get_scared
        end

        Cat.should_receive(:get_scared)
        @dog = Dog.create

      end

    end

    describe "after the method call" do

      it "executes the advice provided after the method is executed" do

        Dog.unadvise_all

        Dog.advise_after(:create) do |point|
          Cat.get_scared
        end

        Cat.should_receive(:get_scared)
        @dog = Dog.create

      end

    end

    describe "after instantiating an instance already" do

      before :each do
        Dog.unadvise_all
        Cat.unadvise_all

        @dog = Dog.new
        @cat = Cat.new
      end

      it "does not execute the advice if none has been defined" do
        @cat.should_not_receive(:hiss!)
        @dog.bark!
      end

      it "executes the advice provided on the already-instantiated instance" do
        Dog.advise_instances_after(:bark!) do |point|
          @cat.hiss!
        end

        @cat.should_receive(:hiss!)
        @dog.bark!
      end

    end

  end

  describe "aspect DSL" do
    class TestAspect < Gazer::Aspect::Base
      before instances_of(Dog) => :bark! do |point|
        Cat.get_scared
      end

      after instances_of(Cat) => :hiss! do |point|
        Dog.new
      end

      before Dog => :create do |point|
        message("creating #{point.object.name}")
      end

      def self.message(text)
      end
    end

    before :all do
      TestAspect.apply!
    end

    before :each do 
      @dog = Dog.new
      @cat = Cat.new

    end

    it "makes the cat run away before the dog barks" do
      Cat.should_receive(:get_scared)
      @dog.bark!
    end

    it "creates a new dog after the cat hisses" do
      Dog.should_receive(:new)
      @cat.hiss!
    end

    it "messages that we are creating a new Dog" do
      TestAspect.should_receive(:message).with("creating Dog")
      Dog.create
    end

  end

end
