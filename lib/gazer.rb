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

      def advice(sym)
        @advice[sym]
      end
    end

    def self.advise_before(sym, &block)
      advise(sym, block)

      str_id = "__#{sym}__hooked__"
      unless private_instance_methods.include?(str_id)
        code = <<-CODE
          class << self
            alias_method #{str_id.inspect}, #{sym.inspect}  
            private #{str_id.inspect}
            define_method #{sym.inspect} do |*args|    
              self.advice(#{sym.inspect}).first.call(:object => self,              # Invoke hook
                         :method => #{sym.inspect}, 
                         :args => args
                        )
              __send__ #{str_id.inspect}, *args  # Invoke backup
            end
          end
        CODE
        instance_eval(code)
      end
    end

    def self.advise_instances_before(sym, &block)
      str_id = "__#{sym}__hooked__"
      unless private_instance_methods.include?(str_id)
        alias_method str_id, sym        # Backup original method
        private str_id                  # Make backup private
        define_method sym do |*args|    # Replace method
          block.call(:object => self,              # Invoke hook
                     :method => sym, 
                     :args => args
                    )
          __send__ str_id, *args  # Invoke backup
        end
      end
    end

  end


end


