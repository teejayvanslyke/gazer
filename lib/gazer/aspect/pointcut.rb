module Gazer
  module Aspect
    class Pointcut
      def initialize(selector, &block)
        @selector = selector
        @block    = block
      end
      
      def remove!; end
    end

    class BeforePointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          BeforeFilter.new(key, @selector[key], &@block).apply!
        end
      end
    end

    class AfterPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          AfterFilter.new(key, @selector[key], &@block).apply!
        end
      end
    end

    class AroundPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          AroundFilter.new(key, @selector[key], &@block).apply!
        end
      end
    end
  end
end
