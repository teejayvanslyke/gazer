%w[rubygems rake rake/clean fileutils newgem hoe rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/gazer'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "gazer"
    s.summary = "poor man's aspect-oriented programming for Ruby"
    s.email = "T.J. VanSlyke"
    s.homepage = "http://github.com/teejayvanslyke/gazer"
    s.description = "poor man's aspect-oriented programming for Ruby"
    s.authors = ["T.J. VanSlyke"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Dir['tasks/**/*.rake'].each { |t| load t }
task :default => :spec
