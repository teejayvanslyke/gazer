module Gazer
  module Aspect
    class InstancesOf
      def initialize(filter)
        if filter.is_a?(Array)
          @filter = filter
        else
          @filter = [ filter ]
        end
      end

      def advise_before(sym, &block)
        @filter.each {|t| t.advise_instances_before(sym, &block)}
      end

      def advise_around(sym, &block)
        @filter.each {|t| t.advise_instances_around(sym, &block)}
      end

      def advise_after(sym, &block)
        @filter.each {|t| t.advise_instances_after(sym, &block)}
      end
    end
  end
end
