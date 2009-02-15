def my_method(&block)
  puts &block
end

my_method { puts 'foo' }


