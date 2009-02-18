module Gazer
  module Aspect
    class Filter
      def initialize(expr)
        if    expr.is_a?(Array)
          @types = expr
        elsif expr.is_a?(Regexp)
          @types = []
          ObjectSpace.each_object(Class) do |c|
            puts "processing #{c}"
            unless c === Class
              @types << c if c.name =~ expr
            end
          end
        else
          @types = [ expr ]
        end
        puts "i got out alive"
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

