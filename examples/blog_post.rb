require File.dirname(__FILE__) + '/../lib/gazer'

class Employee
    def work!; end
end

class LoggingAspect < Gazer::Aspect::Base
    before instances_of(Employee) => :work! do |point|
          puts "#{point.object} just started working."
            end

      after Employee => :new do |point|
            puts "I just created an employee:  #{point.object}"
              end
end

LoggingAspect.apply!

@employee = Employee.new
@employee.work!
