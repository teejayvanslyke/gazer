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

    def self.get_scared
    end
  end

  Gazer::Aspect :cat_fight do

    Dog.advise_instances_before(:bark!) do |point|
      Cat.new.hiss!
    end

    Dog.advise_before(:create) do |point|
      Cat.get_scared
    end

  end

  describe "advising instance methods" do

    describe "before the method call" do

      it "executes the advice provided before the method is executed" do

        @cat = Cat.new
        @dog = Dog.new

        Cat.should_receive(:new).and_return(@cat)
        @cat.should_receive(:hiss!)

        @dog.bark! 

      end

    end

  end

  describe "advising class methods" do

    describe "before the method call" do

      it "executes the advice provided before the method is executed" do

        Cat.should_receive(:get_scared)
        @dog = Dog.create

      end

    end

  end

end
