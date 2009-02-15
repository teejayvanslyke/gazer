module Gazer
  module Aspect
    class InstancesOf
      def initialize(filter)
        @filter = Filter.new(filter)
      end

      def advise_before(sym, &block)
        @filter.advise_instances_before(sym, &block)
      end

      def advise_around(sym, &block)
        @filter.advise_instances_around(sym, &block)
      end

      def advise_after(sym, &block)
        @filter.advise_instances_after(sym, &block)
      end
    end
  end
end
