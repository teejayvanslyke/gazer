module Gazer
  module Aspect
    class Filter

      def initialize(expr, sym, &block)
        if expr.is_a?(Array)
          @types = expr
        else
          @types = [ expr ]
        end

        @method = sym
        @block  = block
      end

      def apply!; raise NotImplementedError; end
    end

    class BeforeFilter < Filter
      def apply!
        @types.each {|t| t.advise_before(@method, &@block)}
      end
    end

    class AroundFilter < Filter
      def apply!
        @types.each {|t| t.advise_around(@method, &@block)}
      end
    end

    class AfterFilter < Filter
      def apply!
        @types.each {|t| t.advise_after(@method, &@block)}
      end
    end
  end
end

