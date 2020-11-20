# class Student
#   attr_accessor :name
#   attr_writer :grade
#   protected
#   attr_reader :grade
#
#   public
#   def initialize(n, g)
#     self.name=(n)
#     self.grade=(g)
#   end
#
#   def better_grade_than?(bob)
#     grade > bob.grade
#   end
# end
#
# joe = Student.new("joe", 96)
# bob = Student.new("bob", 70)
#
# puts "well done!" if joe.better_grade_than?(bob)

class Student

  def initialize(n, g)
    puts @name == self
  end

end

joe = Student.new("joe", 96)
bob = Student.new("bob", 70)
