module Gazer
  module Aspect
    class Filter
      def initialize(expr)
        if expr.is_a?(Array)
          @types = expr
        else
          @types = [ expr ]
        end
      end

      def advise_before(sym, &block)
        @types.each {|t| t.advise_before(sym, &block)}
      end

      def advise_around(sym, &block)
        @types.each {|t| t.advise_around(sym, &block)}
      end

      def advise_after(sym, &block)
        @types.each {|t| t.advise_after(sym, &block)}
      end

      def advise_instances_before(sym, &block)
        @types.each {|t| t.advise_instances_before(sym, &block)}
      end

      def advise_instances_around(sym, &block)
        @types.each {|t| t.advise_instances_around(sym, &block)}
      end

      def advise_instances_after(sym, &block)
        @types.each {|t| t.advise_instances_after(sym, &block)}
      end
    end
  end
end

