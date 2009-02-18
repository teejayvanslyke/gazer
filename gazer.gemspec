# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gazer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["T.J. VanSlyke"]
  s.date = %q{2009-02-17}
  s.description = %q{poor man's aspect-oriented programming for Ruby}
  s.email = %q{T.J. VanSlyke}
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "VERSION.yml", "lib/gazer", "lib/gazer/aspect", "lib/gazer/aspect/base.rb", "lib/gazer/aspect/filter.rb", "lib/gazer/aspect/instance_of.rb", "lib/gazer/aspect/join_point.rb", "lib/gazer/aspect/pointcut.rb", "lib/gazer/aspect.rb", "lib/gazer/object_extensions.rb", "lib/gazer/rails", "lib/gazer/rails/action_controller.rb", "lib/gazer/rails.rb", "lib/gazer.rb", "test/test_aspect_generator.rb", "test/test_generator_helper.rb", "spec/gazer_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/teejayvanslyke/gazer}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{poor man's aspect-oriented programming for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
