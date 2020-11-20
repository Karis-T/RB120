#a module is a collection of bheviours similar to a class except you cannot create objects with it. In order to be used they must be mixed in with a class using the include method.

module Grow
  def grow(itself)
    puts itself
  end
end

class Tree
  include Grow
end

#creating an instance of the Tree class and storing it in the variable wattle
#instantiated an object called wattle from the class Tree
wattle = Tree.new
#wattle is an object/instance of the class Tree
#when we invoke the class method new, the new object is returned.

wattle.grow("The wattle grew some new leaves!")
#The Tree class has access to the .grow instance method via the include method invocation. This is possible through mixing in the module Grow.