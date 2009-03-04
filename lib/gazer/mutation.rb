module Gazer

  class Mutation

    attr_reader :object, :method, :block

    def initialize(object, method, &block)
      @object = object
      @method = method
      @block  = block

      apply!
    end

    def apply!; raise NotImplementedError; end

  end

  # Modifies a single instance's method.  Think instance_eval!
  class InstanceMutation < Mutation

    def initialize(object, method, &block)
      return unless object.respond_to?(method)
      object.advise(method, block)
      super(object, method, &block)
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

  # Modifies an entire class's call to a given method.  Think class_eval!
  class ClassMutation < Mutation

  end

  class BeforeMutation < InstanceMutation

    def apply!
      object.instance_eval(code_for_defining_method(method, 
        [code_for_advice(method), code_for_original(method)]))
    end

  end

  class AroundMutation < InstanceMutation

    def apply!
      code_for_around = <<-CODE
        self.advice_for(#{method.inspect}).last.call(
          Gazer::Aspect::JoinPoint.new(:object => self,
                        :method => #{method.inspect}, 
                        :args   => args,
                        :block  => lambda { __send__ hook, *args }))
      CODE
      object.instance_eval(code_for_defining_method(method, [code_for_around]))
    end

  end

  class AfterMutation < InstanceMutation

    def apply!
      object.instance_eval(code_for_defining_method(method, 
        [code_for_original(method), code_for_advice(method)]))
    end

  end

  class BeforeInstanceMutation < ClassMutation 

    def apply!
      hook    = object.backup_method(method)
      # We need to assign these explicitly since they fall out of 
      # scope...
      block   = self.block
      method  = self.method
      object.__send__ :define_method, method do |*args|    
        block.call(
          Gazer::Aspect::JoinPoint.new(:object => self,
                        :method => method, 
                        :args   => args))
        __send__ hook, *args  # Invoke backup
      end
    end

  end

end

