module Gazer
  module Rails
    module ActionController
      module ClassMethods
        def aspect(*args)
          args.each do |aspect|
            define_method "__apply_#{aspect}_aspect__" do
              eval("#{aspect.to_s.classify}Aspect.apply!")
            end

            before_filter "__apply_#{aspect}_aspect__"
          end
        end
      end
    end
  end
end

ActionController::Base.extend(Gazer::Rails::ActionController::ClassMethods)
