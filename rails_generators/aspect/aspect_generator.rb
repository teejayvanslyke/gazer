class AspectGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'app/aspects'
      m.template  'aspect.erb',  "app/aspects/#{file_name}_aspect.rb"
    end
  end

  protected
    def banner
      <<-EOS
Creates a Gazer aspect.

USAGE: #{$0} #{spec.name} name
EOS
    end
end
