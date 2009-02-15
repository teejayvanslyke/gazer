module Gazer
  module Aspect
    class Pointcut
      def initialize(selector, &block)
        @selector = selector
        @block    = block
      end
    end

    class BeforePointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_before(@selector[key], &@block)
        end
      end
    end

    class AfterPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_after(@selector[key], &@block)
        end
      end
    end

    class AroundPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_around(@selector[key], &@block)
        end
      end
    end
  end
end
