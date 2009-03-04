module Gazer

  class Mutation

    def initialize(object, method, &block)
      @object = object
      @method = method
      @block  = block
    end

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

  class BeforeMutation < Mutation

    def initialize(object, method, &block)
      return unless object.respond_to?(method)
      object.advise(method, block)
      object.instance_eval(code_for_defining_method(method, 
        [code_for_advice(method), code_for_original(method)]))
    end

  end

end

