module Gazer

  module ObjectExtensions

    module ClassMethods
      def advise(sym, block)
        @advice ||= {}
        @advice[sym] ||= []
        @advice[sym] << block
      end

      def advice
        @advice ||= {}
      end

      def advice_for(sym)
        @advice[sym]
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

      def advise_before(sym, &block)
        return unless respond_to?(sym)
        advise(sym, block)
        code = <<-CODE
          class << self
            hook = backup_method(#{sym.inspect})
            define_method #{sym.inspect} do |*args|    
              self.advice_for(#{sym.inspect}).last.call(
                Gazer::Aspect::JoinPoint.new(:object => self,
                              :method => #{sym.inspect}, 
                              :args   => args))
              __send__ hook, *args  # Invoke backup
            end
          end
        CODE
        instance_eval(code)
      end

      def advise_around(sym, &block)
        return unless respond_to?(sym)
        advise(sym, block)
        code = <<-CODE
          class << self
            hook = backup_method(#{sym.inspect})
            define_method #{sym.inspect} do |*args|    
              self.advice_for(#{sym.inspect}).last.call(
                Gazer::Aspect::JoinPoint.new(:object => self,
                              :method => #{sym.inspect}, 
                              :args   => args))
              __send__ hook, *args  # Invoke backup
            end
          end
        CODE
        instance_eval(code)
      end

      def advise_after(sym, &block)
        return unless respond_to?(sym)
        advise(sym, block)
        code = <<-CODE
          class << self
            hook = backup_method(#{sym.inspect})
            define_method #{sym.inspect} do |*args|    
              rval = __send__ hook, *args  # Invoke backup
              self.advice_for(#{sym.inspect}).last.call(
                Gazer::Aspect::JoinPoint.new(:object => self,
                              :method => #{sym.inspect}, 
                              :args   => args))
              return rval
            end
          end
        CODE
        instance_eval(code)
      end

      def advise_instances_before(sym, &block)
        hook = backup_method(sym)
        define_method sym do |*args|    
          block.call(
            Gazer::Aspect::JoinPoint.new(:object => self,
                          :method => sym, 
                          :args   => args))
          __send__ hook, *args  # Invoke backup
        end
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
    end

  end

end

Object.extend(Gazer::ObjectExtensions::ClassMethods)
