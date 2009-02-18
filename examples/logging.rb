# Outputs the following:
#
# Created Employee.
# Created Employee.
# Adding employee #<Employee:0x1be04> to company #<Company:0x1b760>.
# Adding employee #<Employee:0x1ba80> to company #<Company:0x1b760>.
#
require File.dirname(__FILE__) + '/../lib/gazer'

class Employee
  def initialize(valid=true)
    @valid = valid
  end
  def valid?
    @valid
  end
end
class Company
  def add_employee(employee)
  end
end

class LoggingAspect < Gazer::Aspect::Base
  before instances_of(Company) => :add_employee do |point|
    puts "Adding employee #{point.args[0]} to company #{point.object}."
  end

  after Employee => :new do |point|
    puts "Created #{point.object}."
  end

  after (/^.*$/) => :new do |point|
    puts "I just created a new object.  What is it?  It's a #{point.object.class}!"
  end
end

class SecurityAspect < Gazer::Aspect::Base
  before Company => :new do |point|
    puts "We're about to start a company."
  end

  after instances_of(Company) => :add_employee do |point|
    if !point.args[0].valid?
      puts "Added invalid employee to company #{point.object}."
    end
  end
end

LoggingAspect.apply!
SecurityAspect.apply!

employee1 = Employee.new(false)
employee2 = Employee.new
company = Company.new
company.add_employee(employee1)
company.add_employee(employee2)


