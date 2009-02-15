
module Gazer
  module Aspect
    class Base

      class << self

        def add_pointcut(pointcut)
          @pointcuts ||= []
          @pointcuts << pointcut
        end

        attr_accessor :pointcuts

        def instances_of(klass)
          InstancesOf.new(klass)
        end

        def apply!
          pointcuts.each do |pc| pc.apply! end
        end

        def before(selector, &block)
          add_pointcut BeforePointcut.new(selector, &block)
        end

        def after(selector, &block)
          add_pointcut AfterPointcut.new(selector, &block)
        end

        def around(selector, &block)
          add_pointcut AroundPointcut.new(selector, &block)
        end
      end

    end
  end
end
