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

  after :each do
    Dog.unadvise_all
    Cat.unadvise_all
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

  end

end
