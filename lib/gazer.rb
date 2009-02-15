$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Gazer
  VERSION = '0.0.1'

  def self.Aspect(name, &block)
    block.call
  end

  Object.instance_eval do 
    class << self

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

    end

    def self.advise_before(sym, &block)
      advise(sym, block)
      code = <<-CODE
        class << self
          hook = backup_method(#{sym.inspect})
          define_method #{sym.inspect} do |*args|    
            self.advice_for(#{sym.inspect}).first.call(:object => self,              # Invoke hook
                       :method => #{sym.inspect}, 
                       :args => args
                      )
            __send__ hook, *args  # Invoke backup
          end
        end
      CODE
      instance_eval(code)
    end

    def self.advise_instances_before(sym, &block)
      hook = backup_method(sym)
      define_method sym do |*args|    # Replace method
        block.call(:object => self,              # Invoke hook
                   :method => sym, 
                   :args => args
                  )
        __send__ hook, *args  # Invoke backup
      end
    end


    def self.advise_instances_after(sym, &block)
      hook = backup_method(sym)
      define_method sym do |*args|    # Replace method
        rval = __send__ hook, *args  # Invoke backup
        block.call(:object => self,              # Invoke hook
                   :method => sym, 
                   :args => args
                  )
        return rval
      end
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
        define_method sym do |*args|    # Replace method
          __send__ backup_methods_for(sym).first, *args  # Invoke backup
        end
      end
    end

  end


end


