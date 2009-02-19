require 'ostruct'

module Gazer
  module Aspect
    class JoinPoint < OpenStruct
      def yield
        self.block.call
      end
    end
  end
end

