
module Gazer
  module Aspect
    # Gazer::Aspect::Base is the heart of the Gazer API.  It provides a suite
    # of pointcut methods which can be used to filter method calls during the 
    # execution of your application.  See the respective methods for their 
    # usages.
    class Base

      class << self

        # Used to wrap a selector within a pointcut to designate that the 
        # advice should be applied to instance methods.  For example:
        #
        #   before instances_of(User) => :login do |point|
        #     puts "#{point.object} is about to log in."
        #   end
        def instances_of(klass)
          InstancesOf.new(klass)
        end

        # Apply this aspect to your running environment.  Each advised method 
        # will yield a new method on the same object, used to back up the 
        # previous mutation.
        #
        # For instance, if I have advise the method User#login, a new 
        # method User#__login_1__ will be created.  If I advise User#login 
        # again, a method User#__login_2__ will be created.  
        def apply!
          return if @already_applied
          pointcuts.each do |pc| pc.apply! end
          @already_applied = true
        end

        def remove!
          pointcuts.each do |pc| pc.remove! end
        end

        # Execute a block of code immediately before the execution of a given
        # method.
        def before(selector, &block)
          add_pointcut BeforePointcut.new(selector, &block)
        end

        # Execute a block of code immediately after the execution of a given
        # method.
        def after(selector, &block)
          add_pointcut AfterPointcut.new(selector, &block)
        end

        def around(selector, &block)
          add_pointcut AroundPointcut.new(selector, &block)
        end

        attr_accessor :pointcuts

        private 
        def add_pointcut(pointcut)
          @pointcuts ||= []
          @pointcuts << pointcut
        end

      end

    end
  end
end
