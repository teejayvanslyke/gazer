$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


module Gazer
  VERSION = '0.0.1'
end

require 'gazer/mutation'
require 'gazer/object_extensions'
require 'gazer/aspect'
require 'gazer/rails' if defined?(RAILS_ENV)

