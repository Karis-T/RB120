class GoodDog
  @@dog_count = 0

  def self.total_dogs
    @@dog_count
  end

  def initialize
    @@dog_count += 1
  end

end

puts GoodDog.total_dogs

dog1 = GoodDog.new
dog2 = GoodDog.new

puts GoodDog.total_dogs