$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'aspect/join_point'
require 'aspect/pointcut'
require 'aspect/base'
require 'aspect/filter'
require 'aspect/instance_of'

