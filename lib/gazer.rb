$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'ostruct'

module Gazer
  VERSION = '0.0.1'

  module Aspect

    class JoinPoint < OpenStruct; end

    class Pointcut
      def initialize(selector, &block)
        @selector = selector
        @block    = block
      end
    end

    class BeforePointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_before(@selector[key], &@block)
        end
      end
    end

    class AfterPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_after(@selector[key], &@block)
        end
      end
    end

    class AroundPointcut < Pointcut
      def apply!
        @selector.keys.each do |key|
          Filter.new(key).advise_around(@selector[key], &@block)
        end
      end
    end

    class Base

      class << self

        def add_pointcut(pointcut)
          @pointcuts ||= []
          @pointcuts << pointcut
        end

        attr_accessor :pointcuts

        def instances_of(klass)
          InstancesOf.new(klass)
        end

        def apply!
          pointcuts.each do |pc| pc.apply! end
        end

        def before(selector, &block)
          add_pointcut BeforePointcut.new(selector, &block)
        end

        def after(selector, &block)
          add_pointcut AfterPointcut.new(selector, &block)
        end

        def around(selector, &block)
          add_pointcut AroundPointcut.new(selector, &block)
        end
      end

    end

    class Filter
      def initialize(expr)
        if expr.is_a?(Array)
          @types = expr
        else
          @types = [ expr ]
        end
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
                          :args   => args))
          __send__ hook, *args  
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

