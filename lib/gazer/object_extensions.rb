module Gazer

  module ObjectExtensions

    module ClassMethods
      def unadvise_all
        advice.each do |sym, arr|
          code = <<-CODE
            class << self
              alias_method #{sym.inspect}, '__#{sym}_0__'
              public #{sym.inspect}
            end
          CODE
          instance_eval(code)
        end
      end

      def advice_for(sym)
        @advice[sym]
      end

      def advise_before(sym, &block)
        BeforeMutation.new(self, sym, &block)
      end

      def advise_around(sym, &block)
        AroundMutation.new(self, sym, &block)
      end

      def advise_after(sym, &block)
        AfterMutation.new(self, sym, &block)
      end

      def advise_instances_before(sym, &block)
        BeforeInstanceMutation.new(self, sym, &block)
      end

      def advise_instances_around(sym, &block)
        hook = backup_method(sym)
        define_method sym do |*args|    
          block.call(
            Gazer::Aspect::JoinPoint.new(:object => self,
                          :method => sym, 
                          :args   => args,
                          :block  => lambda { __send__ hook, *args }))
        end
      end

      def advise_instances_after(sym, &block)
        hook = backup_method(sym)
        define_method sym do |*args|    # Replace method
          rval = __send__ hook, *args  # Invoke backup
          block.call(
            Gazer::Aspect::JoinPoint.new(:object => self,
                          :method => sym, 
                          :args   => args))
          return rval
        end
      end

      def advise(sym, block)
        @advice ||= {}
        @advice[sym] ||= []
        @advice[sym] << block
      end

      def advice
        @advice ||= {}
      end

      def backup_method(sym)
        id = "__#{sym}_#{backup_methods_for(sym).size}__"
        alias_method id, sym        # Backup original method
        private id                  # Make backup private
        @backup_methods_for ||= {}
        @backup_methods_for[sym] ||= []
        @backup_methods_for[sym] << id
        return id
      end

      def backup_methods_for(sym)
        @backup_methods_for ||= {}
        @backup_methods_for[sym] ||= []
      end

      private
      def code_for_defining_method(sym, parts)
        code = <<-CODE
          class << self
            hook = backup_method(#{sym.inspect})
            define_method #{sym.inspect} do |*args|    
              #{parts.join("\n")}
            end
          end
        CODE
      end

      def code_for_original(sym)
        "__send__ hook, *args"
      end

      def code_for_advice(sym)
        "self.advice_for(#{sym.inspect}).last.call("+
        "Gazer::Aspect::JoinPoint.new(:object => self, :method => #{sym.inspect}, :args => args))"
      end


    end

  end

end

Object.extend(Gazer::ObjectExtensions::ClassMethods)
