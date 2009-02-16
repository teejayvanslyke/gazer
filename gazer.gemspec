(in /Users/bub2000/src/gazer-rails/vendor/gems/gazer-0.1)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gazer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["T.J. VanSlyke"]
  s.date = %q{2009-02-15}
  s.description = %q{}
  s.email = ["tj@elctech.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/gazer.rb", "script/console", "script/destroy", "script/generate", "spec/gazer_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake", "test/test_aspect_generator.rb", "test/test_generator_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{Gazer is a poor man's aspect-oriented programming framework for Ruby.}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gazer}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}
  s.test_files = ["test/test_aspect_generator.rb", "test/test_generator_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
